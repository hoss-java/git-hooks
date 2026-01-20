#!/bin/bash

# GitHub settings
GIT_ROOT="$(git rev-parse --show-toplevel)"
GITHUB_TOKEN="${GITHUB_TOKEN}"
GITHUB_REPO="YOUR_USERNAME/YOUR_REPOSITORY"  # Format: username/repo
DECK_BASE_DIRECTORY="$GIT_ROOT/.pm/deck"                      # Your base directory for boards

# Default values for options
option_output='info'
pm_file="$GIT_ROOT/.pm/pm.md"
md_file="$GIT_ROOT/DECK.md"
collect_options() {
    # Parse options using getopts
    while getopts ":o:-:" opt; do
        case $opt in
            o)
                option_output="$OPTARG"
                ;;
            -)
                case "${OPTARG}" in
                    output)
                        option_output="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    md-file)
                        md_file="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    pm-file)
                        pm_file="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    *)
                        echo "Invalid option: --${OPTARG}" >&2
                        return 1
                        ;;
                esac
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                return 1
                ;;
        esac
    done
    option_output=$(echo "$option_output" | tr '[:upper:]' '[:lower:]')
}

# Function to create a project board
create_board() {
    local board_name="$1"
    local response
    response=$(curl -s -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
                    -d "{\"name\": \"${board_name}\", \"body\": \"Project board for ${board_name}\"}" \
                    "https://api.github.com/repos/${GITHUB_REPO}/projects")
    echo "$response"
}

# Function to create a column in a board
create_column() {
    local board_id="$1"
    local column_name="$2"
    local response
    response=$(curl -s -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
                    -d "{\"name\": \"${column_name}\"}" \
                    "https://api.github.com/projects/${board_id}/columns")
    echo "$response"
}

# Function to create a card in a column
create_card() {
    local column_id="$1"
    local title="$2"
    local body="$3"
    local response
    response=$(curl -s -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
                    -d "{\"note\": \"${body}\", \"content_id\": \"${title}\"}" \
                    "https://api.github.com/projects/columns/${column_id}/cards")
    echo "$response"
}

# Function to extract git-deck cards' headers
extract_card_headers() {
    local file="$1"
    declare -A headers

    header=$(awk '
        BEGIN { in_header=0 }
        /^---/ { 
            in_header = 1 - in_header; 
            if (in_header == 0) exit 
            next
        }
        in_header && length($0) > 0 { print }
    ' "$file")

    while IFS= read -r line; do
        if [[ ! -z "$line" ]]; then
            key=$(echo "$line" | cut -d':' -f1 | xargs)
            value=$(echo "$line" | cut -d':' -f2- | xargs)
            if [[ -n "$key" ]]; then
                headers["$key"]="$value"
            fi
        fi
    done <<< "$header"

    echo "$(declare -p headers)"
}
# Wrapper function that passes all parameters to the main function
extract_status_headers() {
    extract_card_headers "$@"  # Pass all parameters to the main function
}

# Function to extract git-deck cards' body
extract_card_body() {
    local file="$1"
    # Get the content after the second ---
    content=$(awk '
        BEGIN { in_header=0; second_dash_found=0 }
        /^---/ {
            if (in_header) {
                second_dash_found=1;
                in_header=0;
                next;
            }
            in_header=1;
            next;
        }
        second_dash_found { print }
    ' "$file")
    echo -e "$content"
}

# Function to generate a markdown file (DECK.md) from git-deck boards
generate_markdown() {
    return_value=0

    # Clear the output file if it exists
    if [ -f "$pm_file" ]; then
        cat "$pm_file" > "$md_file"
    else
        > "$md_file"
    fi

    # Loop through each board folder
    for board in $DECK_BASE_DIRECTORY/*; do
        # Read board ID from .id file
        board_id=$(<"$board/.id")
        board_name=$(basename "$board")

        # Write the board header only once
        echo "# $board_id - $board_name" >> "$md_file"

        # Loop through each column folder
        for column in "$board"/*; do
            column_name=$(basename "$column")

            # Loop through each card file in the column
            for card in "$column"/*; do
                if [[ $(basename "$card") =~ ^[0-9]{1,4}$ ]]; then
                    card_headers=$(extract_card_headers "$card")
                    eval "$card_headers"  # Evaluate to create the associative array

                    # Get the title from headers, default to "Untitled" if not found
                    card_title="${headers[Title]:-Untitled}"

                    # Initialize card_content and check if headers_output is not empty
                    card_content=""
                    if [[ -n "$card_headers" ]]; then
                        # Get the content after the second ---
                        card_content=$(extract_card_body "$card")
                    fi

                    # Read the status file for statustext and statusdetails
                    status_file="$column/.status"
                    if [[ -f "$status_file" ]]; then
                        status_headers=$(extract_status_headers "$status_file")
                        eval "$status_headers"  # Evaluate to create associative array
                        # Extract values for statustext and statusdetails
                        statustext="${headers[statustext]:-}"
                        statusdetails="${headers[statusdetails]:-}"
                    fi

                    # Get the card ID from the filename
                    card_id=$(basename "$card")
                    board_id_fix=$(printf "%03d" "$board_id")

                    # Write card details to the output markdown file
                    {
                        echo ""
                        echo "## $board_id_fix-$card_id"
                        echo "> **$card_title** ${statustext:-$column_name}"
                        echo "> <details ${statusdetails}>"
                        echo ">     <summary>Details</summary>"

                        # Indent each line of card_content with >
                        while IFS= read -r line; do
                            echo "> $line"
                        done <<< "$card_content"

                        echo "> </details>"
                    } >> "$md_file"
                fi
            done
        done
    done
    return $return_value
}

# Function to update/sync github projects from git-deck boards
update_gh_projects() {
    return_value=0

    # Loop through each board
    for board in $DECK_BASE_DIRECTORY/*/; do
        echo "---board"
        board_name=${board%/}  # Remove trailing slash
        echo "$board_name"
        
        # Create the board in GitHub
        ##board_response=$(create_board "$board_name")
        
        ##if [[ $(echo "$board_response" | jq -r '.id') == "null" ]]; then
        ##    echo "Failed to create board: $board_name"
        ##    echo "$board_response"
        ##    continue
        ##fi
        
        ##board_id=$(echo "$board_response" | jq -r '.id')
        ##echo "Created board: $board_name (ID: $board_id)"

        # Loop through each column in the board
        for column in "$board"*/; do
            column_name=${column%/}  # Remove trailing slash
            column_name=${column_name##*/}  # Get only the column name
            echo "---column"

            echo "$column_name"

            # Create the column in GitHub
            ##column_response=$(create_column "$board_id" "$column_name")
            ##column_id=$(echo "$column_response" | jq -r '.id')
            
            ##echo "   Created column: $column_name (ID: $column_id)"

            # Loop through each card in the column
            for card in "$column"*; do
                if [[ -f "$card" ]]; then
                    card_headers=$(extract_card_headers "$card")
                    eval "$card_headers"  # Evaluate to create the associative array

                    # Get the title from headers, default to "Untitled" if not found
                    card_title="${headers[Title]:-Untitled}"

                                # Initialize card_content and check if headers_output is not empty
                    card_body=""
                    if [[ -n "$card_headers" ]]; then
                        # Get the content after the second ---
                        card_body=$(extract_card_body "$card")
                    fi

                    echo "$card_title"
                    echo "$card_body"
                    # Create the card in GitHub
                    ##card_response=$(create_card "$column_id" "$title" "$body")
                fi
            done
        done
    done
    return $return_value
}

# Main
command="$1"
command=$(echo "$command" | tr '[:upper:]' '[:lower:]')
shift 1 # Shift past the first two parameters
collect_options "${@}"

case "$command" in
    generate-markdown)
            generate_markdown "${@}"
        ;;
    update-gh-projects)
            update_gh_projects "${@}"
        ;;
    *)
        echo "Invalid card command. Usage: $(basename $0) {generate-markdown|update-gh-projects}"
        ;;
esac

git config alias.deck '!bash .git/hooks/git-deck/deck'