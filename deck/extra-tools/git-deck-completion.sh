# Bash completion for git deck and git deck board commands
_git_deck_completion() {
    local current_word prev_word command_name
    current_word="${COMP_WORDS[COMP_CWORD]}"
    prev_word="${COMP_WORDS[COMP_CWORD-1]}"
    command_name="${COMP_WORDS[1]}"

    # Define the first-level commands for "git deck"
    local commands=("pm" "board" "column" "card" "help")

    # First-level command completion
    if [[ "$COMP_CWORD" -eq 2 ]]; then
        COMPREPLY=($(compgen -W "${commands[*]}" -- "$current_word"))
        return
    fi

    # Check if the first command is 'deck' and the second command is 'board'
    if [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "pm" ]]; then
        if [[ "$COMP_CWORD" -eq 3 ]]; then
            # Define second-level commands for "git deck board"
            local pm_commands=("help" "initpm" "editpm" "initdeck" "createdeck")
            COMPREPLY=($(compgen -W "${pm_commands[*]}" -- "$current_word"))
            return
        fi
    fi

    # Check if the first command is 'deck' and the second command is 'board'
    if [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "board" ]]; then
        if [[ "$COMP_CWORD" -eq 3 ]]; then
            # Define second-level commands for "git deck board"
            local board_commands=("help" "ls" "mk" "rm" "set" "cleanup")
            COMPREPLY=($(compgen -W "${board_commands[*]}" -- "$current_word"))
            return
        fi

        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "mk" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            if [[ ("$COMP_CWORD" -eq 5) ]]; then
                # If we successfully obtained the git root, proceed
                local board_options=("--template" "-t")
                COMPREPLY=($(compgen -W "${board_commands[*]}" -- "$current_word"))
            fi

            if [[ ("$COMP_CWORD" -eq 6) ]]; then
                # If we successfully obtained the git root, proceed
                if [[ -d "${git_root}/.pm/deck" ]]; then
                    # List existing board directories in .pm/deck
                    local templates
                    templates=$(git deck board ls --output name --type template)  # Exclude any .id files

                    COMPREPLY=($(compgen -W "${templates}" -- "$current_word"))
                fi
            fi
            return
        fi


        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "rm" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            if [[ ("$COMP_CWORD" -eq 4) ]]; then
                # If we successfully obtained the git root, proceed
                if [[ -d "${git_root}/.pm/deck" ]]; then
                    # List existing board directories in .pm/deck
                    local boards
                    boards=$(git deck board ls --output name)  # Exclude any .id files

                    COMPREPLY=($(compgen -W "${boards}" -- "$current_word"))
                fi
            fi

            if [[ ("$COMP_CWORD" -eq 5) ]]; then
                # If we successfully obtained the git root, proceed
                local board_options=("--remove" "-r")
                COMPREPLY=($(compgen -W "${board_options[*]}" -- "$current_word"))
            fi

            if [[ ("$COMP_CWORD" -eq 6) ]]; then
                # If we successfully obtained the git root, proceed
                local board_option_params=("permanent" )
                COMPREPLY=($(compgen -W "${board_option_params[*]}" -- "$current_word"))
            fi

            return
        fi

        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "set" || "${COMP_WORDS[3]}" == "rm" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            # If we successfully obtained the git root, proceed
            if [[ -d "${git_root}/.pm/deck" ]]; then
                # List existing board directories in .pm/deck
                local boards
                boards=$(git deck board ls --output name)  # Exclude any .id files

                COMPREPLY=($(compgen -W "${boards}" -- "$current_word"))
            fi
            return
        fi
    elif [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "column" ]]; then
        if [[ "$COMP_CWORD" -eq 3 ]]; then
            # Define second-level commands for "git deck board"
            local column_commands=("help" "ls" "mk" "set" "status" "rm" "cleanup")
            COMPREPLY=($(compgen -W "${column_commands[*]}" -- "$current_word"))
            return
        fi

        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "set" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            # If we successfully obtained the git root, proceed
            if [[ -d "${git_root}/.pm/deck" ]]; then
                # List existing board directories in .pm/deck
                local column_s
                columns=$(git deck column ls --output name)

                COMPREPLY=($(compgen -W "${columns}" -- "$current_word"))
            fi
            return
        fi

        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "rm" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            if [[ ("$COMP_CWORD" -eq 4) ]]; then
                # If we successfully obtained the git root, proceed
                if [[ -d "${git_root}/.pm/deck" ]]; then
                    # List existing board directories in .pm/deck
                    local column_s
                    columns=$(git deck column ls --output name)

                    COMPREPLY=($(compgen -W "${columns}" -- "$current_word"))
                fi
            fi

            if [[ ("$COMP_CWORD" -eq 5) ]]; then
                # If we successfully obtained the git root, proceed
                local column_options=("--remove" "-r")
                COMPREPLY=($(compgen -W "${column_options[*]}" -- "$current_word"))
            fi

            if [[ ("$COMP_CWORD" -eq 6) ]]; then
                # If we successfully obtained the git root, proceed
                local column_option_params=("permanent" )
                COMPREPLY=($(compgen -W "${column_option_params[*]}" -- "$current_word"))
            fi

            return
        fi

        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "status" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

           if [[ "$COMP_CWORD" -eq 4 || ( "$COMP_CWORD" -ge 6 && "$((COMP_CWORD % 2))" -eq 0 ) ]]; then
                # If we successfully obtained the git root, proceed
                if [[ -d "${git_root}/.pm/deck" ]]; then
                    # List existing board directories in .pm/deck
                    local column_s
                    columns=$(git deck column ls --output name)
                    columns+=('open')

                    COMPREPLY=($(compgen -W "${columns}" -- "$current_word"))
                fi
            fi

            if [[ ( "$COMP_CWORD" -ge 5 && "$((COMP_CWORD % 2))" -ne 0) ]]; then
                # If we successfully obtained the git root, proceed
                local column_options=("--status-text" "--status-details")
                COMPREPLY=($(compgen -W "${column_options[*]}" -- "$current_word"))
            fi

            return
        fi

    elif [[ "$command_name" == "deck" && "${COMP_WORDS[2]}" == "card" ]]; then
        if [[ "$COMP_CWORD" -eq 3 ]]; then
            # Define second-level commands for "git deck board"
            local card_commands=("help" "ls" "find" "mk" "edit" "cat" "set" "mv" "rm" "cleanup")
            COMPREPLY=($(compgen -W "${card_commands[*]}" -- "$current_word"))
            return
        fi

        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "edit"  || "${COMP_WORDS[3]}" == "cat" || \
            "${COMP_WORDS[3]}" == "set" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            # If we successfully obtained the git root, proceed
            if [[ -d "${git_root}/.pm/deck" ]]; then
                # List existing cars directories in .pm/deck
                local cards
                cards=$(git deck card ls --output short)

                COMPREPLY=($(compgen -W "${cards}" -- "$current_word"))
            fi
            return
        fi


        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "rm" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"

            if [[ ("$COMP_CWORD" -eq 4) ]]; then
                # If we successfully obtained the git root, proceed
                if [[ -d "${git_root}/.pm/deck" ]]; then
                    # List existing cars directories in .pm/deck
                    local cards
                    cards=$(git deck card ls --output short)

                    COMPREPLY=($(compgen -W "${cards}" -- "$current_word"))
                fi
            fi

            if [[ ("$COMP_CWORD" -eq 5) ]]; then
                # If we successfully obtained the git root, proceed
                local card_options=("--remove" "-r")
                COMPREPLY=($(compgen -W "${card_options[*]}" -- "$current_word"))
            fi

            if [[ ("$COMP_CWORD" -eq 6) ]]; then
                # If we successfully obtained the git root, proceed
                local card_option_params=("permanent" )
                COMPREPLY=($(compgen -W "${card_option_params[*]}" -- "$current_word"))
            fi
            return
        fi


        # Autocompletion for 'set' command
        if [[ "${COMP_WORDS[3]}" == "mv" ]]; then
            # Get the Git root directory
            local git_root
            git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
            # If we successfully obtained the git root, proceed
            if [[ -d "${git_root}/.pm/deck" ]]; then
                if [[ "$COMP_CWORD" -eq 4 ]]; then
                    # List existing cars directories in .pm/deck
                    local cards
                    cards=$(git deck card ls --output short)

                    COMPREPLY=($(compgen -W "${cards}" -- "$current_word"))
                elif [[ "$COMP_CWORD" -eq 5 ]]; then
                    # List existing cars directories in .pm/deck
                    local columns
                    columns=$(git deck column ls --output name)

                    COMPREPLY=($(compgen -W "${columns}" -- "$current_word"))
                fi
            fi
            return
        fi
    fi
}

# Register the completion function specifically for git deck
complete -F _git_deck_completion git deck
