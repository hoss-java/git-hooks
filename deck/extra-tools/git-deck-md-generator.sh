#!/bin/bash

#---
# @file git-deck-md-generator.sh
# @brief A script to generate a markdown representation of a card deck from structured card files.
# This script extracts headers from card files and organizes them into a markdown deck output.
# It reads card details from specified directories in a Git repository and outputs
# the structured information to a markdown file, organizing the cards by board and column.
#---

# Get the root directory of the Git repository
GIT_ROOT="$(git rev-parse --show-toplevel)"
base_path="$GIT_ROOT/.pm/deck"
pm_file="$GIT_ROOT/.pm/pm.md"
output_file="$GIT_ROOT/DECK.md"

#---
# @brief Extract the headers from a given card file.
# This function reads a card file and extracts key-value pairs from the
# headers, which are defined between the YAML '---' delimiters.
# @param file The path to the card file.
# @return A string representation of an associative array containing the headers.
#---
extract_headers() {
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

#---
# @brief Create a markdown representation of the deck.
#
# This function iterates through the card files in the designated directory
# structure, extracting relevant data and writing it to an output markdown file.
#
# It handles board folders, column folders, and card files,
# generating an organized structure in the markdown file.
#---
create_deck() {
    return_value=1
    # Clear the output file if it exists
    if [ -f "$pm_file" ]; then
        cat "$pm_file" > "$output_file"
    else
        > "$output_file"
    fi

    # Loop through each board folder
    for board_folder in "$base_path"/*; do
        if [[ -d "$board_folder" ]]; then
            # Read board ID from .id file
            board_id=$(<"$board_folder/.id")
            board_name=$(basename "$board_folder")

            # Write the board header only once
            echo "# $board_id - $board_name" >> "$output_file"

            # Loop through each column folder
            for column_folder in "$board_folder"/*; do
                if [[ -d "$column_folder" ]]; then
                    column_name=$(basename "$column_folder")

                    # Loop through each card file in the column
                    for card_file in "$column_folder"/*; do
                        if [[ -f "$card_file" && $(basename "$card_file") =~ ^[0-9]{1,4}$ ]]; then
                            headers_output=$(extract_headers "$card_file")
                            eval "$headers_output"  # Evaluate to create the associative array

                            # Get the title from headers, default to "Untitled" if not found
                            card_title="${headers[Title]:-Untitled}"

                            # Initialize card_content and check if headers_output is not empty
                            card_content=""
                            if [[ -n "$headers_output" ]]; then
                                # Get the content after the second ---
                                card_content=$(awk '
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
                                ' "$card_file")
                            fi

                            # Read the status file for statustext and statusdetails
                            status_file="$column_folder/.status"
                            if [[ -f "$status_file" ]]; then
                                status_headers_output=$(extract_headers "$status_file")
                                eval "$status_headers_output"  # Evaluate to create associative array
                                # Extract values for statustext and statusdetails
                                statustext="${headers[statustext]:-}"
                                statusdetails="${headers[statusdetails]:-}"
                            fi

                            # Get the card ID from the filename
                            card_id=$(basename "$card_file")
                            board_id_fix=$(printf "%03d" "$board_id")

                            # Write card details to the output markdown file
                            {
                                echo ""
                                echo "## [B$board_id_fix-C$card_id] $card_title ${statustext:-$column_name}"
                                echo "> <details ${statusdetails}>"
                                echo ">     <summary>Details</summary>"

                                # Indent each line of card_content with >
                                while IFS= read -r line; do
                                    echo "> $line"
                                done <<< "$card_content"

                                echo "> </details>"
                            } >> "$output_file"
                        fi
                    done
                fi
            done
        fi
    done
}

# Main
create_deck