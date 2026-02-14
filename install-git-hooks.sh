#!/bin/bash
# Get the directory where the script is located
script_dir="$(dirname "$0")"

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: This script must be run inside a Git repository."
    exit 1
fi

# Define the paths
target_git_root_dir="$(git rev-parse --show-toplevel)"
target_git_hooks_dir="$target_git_root_dir/.git/hooks"
source_git_hooks_dir="$script_dir/hooks"
source_git_default_file="$script_dir/hooks/.gitdefault"
source_completion_script="$script_dir/extra-tools/git-deck-completion.sh"
target_user_home="$HOME"

echo "Source folder :$script_dir"
echo "Current git folder :$target_git_root_dir"

# User prompt for confirmation
read -p "Do you want to continue with the installation? (yes/no): " answer

# Check the user's response
case "$answer" in
    yes|YES|y|Y)
        echo "Continuing with the installation..."
        ;;
    no|NO|n|N)
        echo "Installation aborted."
        exit 0
        ;;
    *)
        echo "Invalid response. Please answer yes or no."
        exit 1
        ;;
esac

# Copy hooks and git-deck to the Git root folder
if [[ -d "$source_git_hooks_dir" ]]; then
    cp -R "$source_git_hooks_dir/"* "$target_git_hooks_dir/"
    echo "Copied hooks and git-deck to $target_git_hooks_dir"
    git config alias.deck '!bash .git/hooks/git-deck/deck'
    echo "git-deck command was registered."
else
    echo "Error: hooks and git-deck not found at $source_git_hooks_dir"
    exit 1
fi

# Copy .gitdefault to the Git root folder
if [[ -f "$source_git_default_file" ]]; then
    cp "$source_git_default_file" "$target_git_root_dir/"
    echo "Copied .gitdefault to $target_git_root_dir"
else
    echo "Warning: .gitdefault not found at $source_git_default_file"
fi

# Copy the completion script to the user's home directory
if [[ -f "$source_completion_script" ]]; then
    cp "$source_completion_script" "$target_user_home/"
    echo "Copied git-deck-completion.sh to $target_user_home"
else
    echo "Warning: git-deck-completion.sh not found at $source_completion_script"
fi

# Add sourcing to .bashrc if not already present
if ! grep -q "source .*/git-deck-completion.sh" "$target_user_home/.bashrc"; then
    echo "source $target_user_home/git-deck-completion.sh" >> "$target_user_home/.bashrc"
    echo "Added sourcing to .bashrc"
else
    echo "Sourcing already present in .bashrc"
fi

# Add sourcing to .bash_profile if not already present
if ! grep -q "source .*/git-deck-completion.sh" "$target_user_home/.bash_profile"; then
    echo "source $target_user_home/git-deck-completion.sh" >> "$target_user_home/.bash_profile"
    echo "Added sourcing to .bash_profile"
else
    echo "Sourcing already present in .bash_profile"
fi

echo "Installation completed."