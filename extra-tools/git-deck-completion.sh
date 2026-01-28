# Bash completion for git deck and git deck board commands
_git_deck_completion() {
    local current_word prev_word command_name
    current_word="${COMP_WORDS[COMP_CWORD]}"
    prev_word="${COMP_WORDS[COMP_CWORD-1]}"
    command_name="${COMP_WORDS[1]}"

    # Check if in a Git repository
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        return  # Not in a Git repository, exit the function
    fi

    # Check if the 'git deck' file exists
    if [ ! -f ".git/hooks/git-deck/deck" ]; then
        return  # 'git deck' command not available, exit the function
    fi

    if [[ "${COMP_WORDS[0]}" == "git" ]]; then
        if [[ "$command_name" == "commit" ]]; then
            if [[ "$COMP_CWORD" -eq 3 && "$prev_word" == "-m" ]]; then
                COMPREPLY=($(compgen -W "$(git deck card ls --output commitid)" -- "$current_word"))
                return
            elif [[ "$COMP_CWORD" -gt 3 ]]; then
                local title_word_array
                title_word_array=$(git deck card ls --output titleonly)
                local unique_array=($(printf "%s\n" "${title_word_array[@]}" | tr '[:upper:]' '[:lower:]' | sort -u))
                COMPREPLY=($(compgen -W "${unique_array[*]}" -- "$current_word"))
                return
            fi
         elif [[ "$command_name" == "deck" ]]; then
             # First-level command completion
             if [[ "$COMP_CWORD" -eq 2 ]]; then
                 COMPREPLY=($(compgen -W "$(git deck _completion "$COMP_CWORD" ${COMP_WORDS[@]})" -- "$current_word"))
                 return
             fi

             # Check if the first command is 'deck' and the second command is 'pm'
             if [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "pm" ]]; then
                 COMPREPLY=($(compgen -W "$(git deck pm _completion "$COMP_CWORD" ${COMP_WORDS[@]})" -- "$current_word"))
                 return
             # Check if the first command is 'deck' and the second command is 'board'
             elif [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "board" ]]; then
                 COMPREPLY=($(compgen -W "$(git deck board _completion "$COMP_CWORD" ${COMP_WORDS[@]})" -- "$current_word"))
                 return
             # Check if the first command is 'deck' and the second command is 'column'
             elif [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "column" ]]; then
                 COMPREPLY=($(compgen -W "$(git deck column _completion "$COMP_CWORD" ${COMP_WORDS[@]})" -- "$current_word"))
                 return
             # Check if the first command is 'deck' and the second command is 'card'
             elif [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "card" ]]; then
                 COMPREPLY=($(compgen -W "$(git deck card _completion "$COMP_CWORD" ${COMP_WORDS[@]})" -- "$current_word"))
                 return
             fi
         fi
    fi
}

# Register the completion function specifically for git deck
complete -F _git_deck_completion git deck
