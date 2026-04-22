#!/bin/bash

#############################################################################
# Project Manager - Git-based Kanban Board Analyzer
# Analyzes card transitions and generates time tracking reports
#############################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#############################################################################
# STEP 0: Verify Git Repository
#############################################################################

verify_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Error: Not a git repository${NC}"
        echo "Please run this script from the root of a git repository."
        exit 1
    fi
    
    GIT_ROOT=$(git rev-parse --show-toplevel)
    echo -e "${GREEN}✓ Git repository found: ${GIT_ROOT}${NC}"
}

#############################################################################
# STEP 1: Discover All Boards
#############################################################################

discover_boards() {
    local pm_path="${GIT_ROOT}/.pm/deck"
    
    if [[ ! -d "$pm_path" ]]; then
        echo -e "${RED}❌ Error: No .pm/deck directory found${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Scanning for boards...${NC}"
    
    BOARDS=()
    while IFS= read -r -d '' board_dir; do
        board_name=$(basename "$board_dir")
        # Skip hidden files, .bin, and .default
        if [[ ! "$board_name" =~ ^\. ]] && [[ "$board_name" != "bin" ]]; then
            BOARDS+=("$board_name")
            echo -e "${GREEN}  ✓ Found board: ${YELLOW}${board_name}${NC}"
        fi
    done < <(find "$pm_path" -maxdepth 1 -mindepth 1 -type d -print0)
    
    if [[ ${#BOARDS[@]} -eq 0 ]]; then
        echo -e "${RED}❌ No boards found${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Total boards found: ${#BOARDS[@]}${NC}\n"
}

#############################################################################
# STEP 2: Find All Cards in a Board
#############################################################################

find_cards_in_board() {
    local board=$1
    local board_path="${GIT_ROOT}/.pm/deck/${board}"
    local cards=()
    
    # Search for cards in NOT-STARTED, ONGOING, and DONE folders
    for status_dir in "NOT-STARTED" "ONGOING" "DONE"; do
        local status_path="${board_path}/${status_dir}"
        if [[ -d "$status_path" ]]; then
            while IFS= read -r -d '' card_file; do
                local card_name=$(basename "$card_file")
                # Only include 4-digit card numbers
                if [[ "$card_name" =~ ^[0-9]{4}$ ]]; then
                    cards+=("$card_name")
                fi
            done < <(find "$status_path" -maxdepth 1 -type f -print0)
        fi
    done
    
    # Remove duplicates and sort
    printf '%s\n' "${cards[@]}" | sort -u
}

#############################################################################
# STEP 3: Get Current Status of Card
#############################################################################

get_card_status() {
    local board=$1
    local card=$2
    local board_path="${GIT_ROOT}/.pm/deck/${board}"
    
    if [[ -f "${board_path}/NOT-STARTED/${card}" ]]; then
        echo "NOT-STARTED"
    elif [[ -f "${board_path}/ONGOING/${card}" ]]; then
        echo "ONGOING"
    elif [[ -f "${board_path}/DONE/${card}" ]]; then
        echo "DONE"
    else
        echo "UNKNOWN"
    fi
}

#############################################################################
# STEP 4: Find Card Creation Date
#############################################################################

find_card_created_date() {
    local board=$1
    local card=$2
    local board_path=".pm/deck/${board}"
    
    # Find the FIRST commit where card file appears in NOT-STARTED
    local commit=$(git log --follow --format='%H' --reverse -- "${board_path}/NOT-STARTED/${card}" 2>/dev/null | head -1)
    
    if [[ -n "$commit" ]]; then
        git log -1 --format='%ai' "$commit"
    else
        # Fallback: check file creation time in filesystem
        for status_dir in "NOT-STARTED" "ONGOING" "DONE"; do
            local file_path="${GIT_ROOT}/.pm/deck/${board}/${status_dir}/${card}"
            if [[ -f "$file_path" ]]; then
                stat -c %y "$file_path" 2>/dev/null | cut -d' ' -f1,2 | head -c 19
                echo ""
                return
            fi
        done
        echo "UNKNOWN"
    fi
}

#############################################################################
# STEP 5: Find Card Moved to ONGOING Date
#############################################################################

find_card_moved_to_ongoing_date() {
    local board=$1
    local card=$2
    local board_path=".pm/deck/${board}"
    
    # Find FIRST commit where card appears in ONGOING folder
    local commit=$(git log --follow --format='%H' --reverse -- "${board_path}/ONGOING/${card}" 2>/dev/null | head -1)
    
    if [[ -n "$commit" ]]; then
        git log -1 --format='%ai' "$commit"
    else
        echo "UNKNOWN"
    fi
}

#############################################################################
# STEP 6: Find Card Moved to DONE Date
#############################################################################

find_card_moved_to_done_date() {
    local board=$1
    local card=$2
    local board_path=".pm/deck/${board}"
    
    # Find LAST commit where card appears in DONE folder
    local commit=$(git log --follow --format='%H' -- "${board_path}/DONE/${card}" 2>/dev/null | head -1)
    
    if [[ -n "$commit" ]]; then
        git log -1 --format='%ai' "$commit"
    else
        echo "UNKNOWN"
    fi
}

#############################################################################
# STEP 7: Parse Card Header
#############################################################################

parse_card_header() {
    local board=$1
    local card=$2
    local board_path="${GIT_ROOT}/.pm/deck/${board}"
    
    local title=""
    local tags=""
    local creator=""
    local assigned_to=""
    
    # Try to find card in one of the status directories
    for status_dir in "NOT-STARTED" "ONGOING" "DONE"; do
        local card_file="${board_path}/${status_dir}/${card}"
        if [[ -f "$card_file" ]]; then
            # Extract YAML header between --- markers
            title=$(grep "^Title:" "$card_file" | sed 's/Title: //' | head -1)
            tags=$(grep "^Tags:" "$card_file" | sed 's/Tags: //' | head -1)
            creator=$(grep "^Creator:" "$card_file" | sed 's/Creator: //' | head -1)
            assigned_to=$(grep "^AssignedTo:" "$card_file" | sed 's/AssignedTo: //' | head -1)
            break
        fi
    done
    
    echo "${title}|${tags}|${creator}|${assigned_to}"
}

#############################################################################
# STEP 8: Calculate Time Between Two Dates
#############################################################################

calculate_time_between() {
    local date1=$1
    local date2=$2
    
    if [[ "$date1" == "UNKNOWN" ]] || [[ "$date2" == "UNKNOWN" ]]; then
        echo "N/A|N/A"
        return
    fi
    
    local timestamp1=$(date -d "$date1" +%s 2>/dev/null || echo "0")
    local timestamp2=$(date -d "$date2" +%s 2>/dev/null || echo "0")
    
    if [[ $timestamp1 -eq 0 ]] || [[ $timestamp2 -eq 0 ]]; then
        echo "N/A|N/A"
    else
        local diff=$((timestamp2 - timestamp1))
        local days=$((diff / 86400))
        local hours=$(((diff % 86400) / 3600))
        echo "${days}d|${hours}h"
    fi
}

#############################################################################
# STEP 9: Format Time for Display
#############################################################################

format_time_display() {
    local time_str=$1
    
    if [[ "$time_str" == "N/A|N/A" ]]; then
        echo "-"
    else
        echo "$time_str"
    fi
}

#############################################################################
# STEP 10: Get Total Time from ONGOING to DONE (Only Actual Work Time)
#############################################################################

get_total_work_time() {
    local board=$1
    local card=$2
    local status=$3
    
    local to_ongoing=$(find_card_moved_to_ongoing_date "$board" "$card")
    local to_done=$(find_card_moved_to_done_date "$board" "$card")
    
    # If card is still in NOT-STARTED, no work time
    if [[ "$status" == "NOT-STARTED" ]]; then
        echo "N/A|N/A|NOT-STARTED"
        return
    fi
    
    # If card is in ONGOING but not DONE yet
    if [[ "$status" == "ONGOING" ]]; then
        echo "N/A|N/A|IN-PROGRESS"
        return
    fi
    
    # Card is DONE, calculate work time
    if [[ "$to_ongoing" != "UNKNOWN" ]] && [[ "$to_done" != "UNKNOWN" ]]; then
        calculate_time_between "$to_ongoing" "$to_done"
        echo "|COMPLETED"
    else
        # Try to use DONE as fallback for ONGOING if ONGOING not found
        if [[ "$to_ongoing" == "UNKNOWN" ]] && [[ "$to_done" != "UNKNOWN" ]]; then
            echo "N/A|N/A|COMPLETED"
        else
            echo "N/A|N/A|COMPLETED"
        fi
    fi
}

#############################################################################
# STEP 11: Generate Report with Fixed Table Formatting
#############################################################################

generate_report() {
    local board=$1
    
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Board: ${YELLOW}${board}${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════${NC}\n"
    
    # Print header with fixed alignment
    printf "%-6s | %-28s | %-16s | %-16s | %-16s | %-10s | %-12s | %-10s\n" \
        "Card" "Title" "Created" "Start Work" "Completed" "In Queue" "Working Time" "Status"
    printf "%-6s | %-28s | %-16s | %-16s | %-16s | %-10s | %-12s | %-10s\n" \
        "────" "────────────────────────────" "────────────────" "────────────────" "────────────────" "──────────" "────────────────" "──────────"
    
    local card_count=0
    local completed_count=0
    
    # Variables to track first ONGOING and last DONE for summary
    local first_ongoing_date="UNKNOWN"
    local last_done_date="UNKNOWN"
    
    local cards=$(find_cards_in_board "$board")
    
    # Sort cards by completion date (DONE first, then ONGOING, then NOT-STARTED)
    declare -A card_dates
    
    while IFS= read -r card; do
        [[ -z "$card" ]] && continue
        
        local status=$(get_card_status "$board" "$card")
        local to_done=$(find_card_moved_to_done_date "$board" "$card")
        
        if [[ "$to_done" != "UNKNOWN" ]]; then
            card_dates[$card]=$(date -d "$to_done" +%s)
        else
            card_dates[$card]="0"
        fi
    done <<< "$cards"
    
    # Sort cards by date (descending - newest first)
    mapfile -t sorted_cards < <(for card in "${!card_dates[@]}"; do echo "$card ${card_dates[$card]}"; done | sort -k2 -rn | cut -d' ' -f1)
    
    for card in "${sorted_cards[@]}"; do
        [[ -z "$card" ]] && continue
        
        local status=$(get_card_status "$board" "$card")
        local created=$(find_card_created_date "$board" "$card")
        local to_ongoing=$(find_card_moved_to_ongoing_date "$board" "$card")
        local to_done=$(find_card_moved_to_done_date "$board" "$card")
        
        # Track first ONGOING and last DONE for summary
        if [[ "$to_ongoing" != "UNKNOWN" ]]; then
            if [[ "$first_ongoing_date" == "UNKNOWN" ]]; then
                first_ongoing_date=$to_ongoing
            else
                # Keep the earlier date
                local first_timestamp=$(date -d "$first_ongoing_date" +%s)
                local current_timestamp=$(date -d "$to_ongoing" +%s)
                if [[ $current_timestamp -lt $first_timestamp ]]; then
                    first_ongoing_date=$to_ongoing
                fi
            fi
        fi
        
        if [[ "$to_done" != "UNKNOWN" ]]; then
            if [[ "$last_done_date" == "UNKNOWN" ]]; then
                last_done_date=$to_done
            else
                # Keep the later date
                local last_timestamp=$(date -d "$last_done_date" +%s)
                local current_timestamp=$(date -d "$to_done" +%s)
                if [[ $current_timestamp -gt $last_timestamp ]]; then
                    last_done_date=$to_done
                fi
            fi
        fi
        
        # Get queue time (NOT-STARTED to ONGOING)
        local time_in_queue=$(calculate_time_between "$created" "$to_ongoing")
        
        # Get work time (ONGOING to DONE)
        local time_working=$(calculate_time_between "$to_ongoing" "$to_done")
        
        # Handle different statuses
        local queue_display="-"
        local work_display="-"
        local status_display="$status"
        
        if [[ "$status" == "NOT-STARTED" ]]; then
            queue_display="-"
            work_display="-"
        elif [[ "$status" == "ONGOING" ]]; then
            queue_display=$(format_time_display "$time_in_queue")
            work_display="-"
            status_display="IN-PROGRESS"
        elif [[ "$status" == "DONE" ]]; then
            if [[ "$to_ongoing" != "UNKNOWN" ]]; then
                queue_display=$(format_time_display "$time_in_queue")
                work_display=$(format_time_display "$time_working")
            else
                queue_display="-"
                work_display="-"
            fi
            completed_count=$((completed_count + 1))
        fi
        
        # Parse card header
        local header_info=$(parse_card_header "$board" "$card")
        local title=$(echo "$header_info" | cut -d'|' -f1)
        title="${title:0:26}"
        
        # Format dates for display (YYYY-MM-DD HH:MM)
        local created_display="-"
        local ongoing_display="-"
        local done_display="-"
        
        [[ "$created" != "UNKNOWN" ]] && created_display=$(echo "$created" | cut -c1-16)
        [[ "$to_ongoing" != "UNKNOWN" ]] && ongoing_display=$(echo "$to_ongoing" | cut -c1-16)
        [[ "$to_done" != "UNKNOWN" ]] && done_display=$(echo "$to_done" | cut -c1-16)
        
        printf "%-6s | %-28s | %-16s | %-16s | %-16s | %-10s | %-12s | %-10s\n" \
            "$card" "$title" "$created_display" "$ongoing_display" "$done_display" "$queue_display" "$work_display" "$status_display"
        
        card_count=$((card_count + 1))
    done
    
    printf "%-6s | %-28s | %-16s | %-16s | %-16s | %-10s | %-12s | %-10s\n" \
        "════" "════════════════════════════" "════════════════" "════════════════" "════════════════" "══════════" "════════════════" "══════════"
    
    # Calculate total project time (from first ONGOING to last DONE)
    local total_project_time=$(calculate_time_between "$first_ongoing_date" "$last_done_date")
    local project_days="-"
    local project_hours="-"
    
    if [[ "$total_project_time" != "N/A|N/A" ]]; then
        project_days=$(echo "$total_project_time" | cut -d'|' -f1)
        project_hours=$(echo "$total_project_time" | cut -d'|' -f2)
    fi
    
    echo -e "\n${YELLOW}Summary for ${board}:${NC}"
    echo -e "  Total cards: ${GREEN}${card_count}${NC}"
    echo -e "  Completed cards: ${GREEN}${completed_count}${NC}"
    echo -e "  Project timeline: ${GREEN}${project_days} / ${project_hours}${NC}"
    echo -e "  First work started: ${GREEN}${first_ongoing_date}${NC}"
    echo -e "  Last work completed: ${GREEN}${last_done_date}${NC}"
}

#############################################################################
# STEP 12: Generate JSON Report
#############################################################################

generate_json_report() {
    local output_file="${GIT_ROOT}/pm_report.json"
    
    echo "{" > "$output_file"
    echo "  \"generated_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$output_file"
    echo "  \"git_root\": \"${GIT_ROOT}\"," >> "$output_file"
    echo "  \"boards\": [" >> "$output_file"
    
    local first_board=true
    
    for board in "${BOARDS[@]}"; do
        if [[ "$first_board" == false ]]; then
            echo "," >> "$output_file"
        fi
        first_board=false
        
        echo -n "    {" >> "$output_file"
        echo -n "\"name\": \"${board}\", \"cards\": [" >> "$output_file"
        
        local first_card=true
        local cards=$(find_cards_in_board "$board")
        
        while IFS= read -r card; do
            [[ -z "$card" ]] && continue
            
            if [[ "$first_card" == false ]]; then
                echo -n ", " >> "$output_file"
            fi
            first_card=false
            
            local status=$(get_card_status "$board" "$card")
            local created=$(find_card_created_date "$board" "$card")
            local to_ongoing=$(find_card_moved_to_ongoing_date "$board" "$card")
            local to_done=$(find_card_moved_to_done_date "$board" "$card")
            
            local header_info=$(parse_card_header "$board" "$card")
            local title=$(echo "$header_info" | cut -d'|' -f1)
            local tags=$(echo "$header_info" | cut -d'|' -f2)
            local creator=$(echo "$header_info" | cut -d'|' -f3)
            local assigned_to=$(echo "$header_info" | cut -d'|' -f4)
            
            echo -n "{\"card\": \"${card}\", \"status\": \"${status}\", \"title\": \"${title//\"/\\\"}\", \"tags\": \"${tags}\", \"creator\": \"${creator}\", \"assigned_to\": \"${assigned_to}\", \"dates\": {\"created\": \"${created}\", \"to_ongoing\": \"${to_ongoing}\", \"to_done\": \"${to_done}\"}}" >> "$output_file"
        done <<< "$cards"
        
        echo -n "]}" >> "$output_file"
    done
    
    echo "" >> "$output_file"
    echo "  ]" >> "$output_file"
    echo "}" >> "$output_file"
    
    echo -e "${GREEN}✓ JSON report saved to: ${YELLOW}${output_file}${NC}"
}

#############################################################################
# MAIN EXECUTION
#############################################################################

main() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       Project Manager - Kanban Board Analyzer             ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}\n"
    
    # Step 0: Verify git repo
    verify_git_repo
    
    # Step 1: Discover boards
    discover_boards
    
    # Step 2-11: Generate reports for each board
    for board in "${BOARDS[@]}"; do
        generate_report "$board"
    done
    
    # Step 12: Generate JSON report
    echo ""
    generate_json_report
    
    echo -e "\n${GREEN}✓ Analysis complete!${NC}\n"
}

# Run main function
main "$@"

