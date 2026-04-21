# Git-Deck

The **Git-Deck** is a powerful tool designed to manage your Kanban boards directly through Git. With features that allow you to create, edit, and manage boards, columns, and cards, it integrates seamlessly with your existing workflow.

## Purpose
The Git-Deck allows you to perform various operations related to Kanban boards, making it easier to track tasks and manage projects efficiently. 

## Register git-deck
Before starting to use the deck command, it needs to be registered as a Git command.

```bash
git config alias.deck '!bash .git/hooks/git-deck/deck'
```

## Commands Overview

### Board Commands
- **Help**: `git deck board help`
- **List**: `git deck board ls`
- **Create**: `git deck board mk <board-name>`
- **Set**: `git deck board set <board-name>`
- **Remove**: `git deck board rm <board-name>`
- **Cleanup**: `git deck board cleanup`

### Column Commands
- **Help**: `git deck column help`
- **List**: `git deck column ls`
- **Create**: `git deck column mk <column-name>`
- **Set**: `git deck column set <column-name>`
- **Status**: `git deck column status <column-name>`
- **Remove**: `git deck column rm <column-name>`
- **Cleanup**: `git deck column cleanup`

### Card Commands
- **Help**: `git deck card help`
- **List**: `git deck card ls`
- **Find**: `git deck card find <card-name>`
- **Create**: `git deck card mk <card-name>`
- **Edit**: `git deck card edit <card-name>`
- **View**: `git deck card cat <card-name>`
- **Set**: `git deck card set <card-name>`
- **Move**: `git deck card mv <card-name> <column-name>`
- **Remove**: `git deck card rm <card-name>`
- **Cleanup**: `git deck card cleanup`

### Project Management Command
- **Command**: `git deck pm`

## Usage
To access the Git Deck commands, use the following syntax:

```bash
git deck {<command>|help}
```

# Git-Deck Technical Guide

## Overview

**Git-Deck** is a terminal-based Kanban board system integrated directly into Git workflows. It manages **boards**, **columns**, and **cards** using shell scripts stored in `.git/hooks/git-deck/`. The system uses a modular architecture where each feature (board, card, column, pm) is a self-contained module with subcommands.

---

# Git-Deck Technical Architecture & Developer Guide

**Git-Deck** is a modular, bash-based Kanban board management system designed to integrate seamlessly with Git workflows. This document explains the architecture, design patterns, and how to extend Git-Deck by creating new modules.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Directory Structure](#directory-structure)
3. [Core Concepts](#core-concepts)
4. [Module System](#module-system)
5. [Creating a New Module](#creating-a-new-module)
6. [Hook System](#hook-system)
7. [Common Patterns & Best Practices](#common-patterns--best-practices)
8. [Library Functions](#library-functions)

---

## Architecture Overview

**Git-Deck** follows a **modular, plugin-based architecture** where functionality is organized into self-contained modules. Each module is responsible for a specific feature domain (board, column, card, project management) and is invoked through a unified command interface.

### Key Design Principles

| Principle | Description |
|-----------|-------------|
| **Modularity** | Each feature domain (board, column, card, pm) is a standalone module loaded at runtime. |
| **Dynamic Command Discovery** | Commands are automatically discovered from function naming conventions, reducing boilerplate. |
| **Hook System** | Pre/post hooks allow modules to react to events without tight coupling. |
| **Shared Libraries** | Common functionality is extracted into `.shinc` (shell include) files for reuse. |
| **Consistent Interface** | All modules follow the same command structure: `git deck {module} {subcommand} {args}`. |

---

## Directory Structure

```
.git/hooks/git-deck/
├── deck                          # Main entry point
├── deck.help                      # Help documentation
├── decklib.shinc                  # Core utility functions
├── decklib.shinc                  # Shared library functions
├── mdheaderlib.shinc              # Markdown header manipulation
├── colorcodes.shinc               # Color output utilities
├── deckhook.shinc                 # Hook system implementation
│
├── modules/                       # Module container
│   ├── _completion.shinc          # Bash autocompletion
│   ├── board.shinc                # Board module (entry point)
│   ├── column.shinc               # Column module (entry point)
│   ├── card.shinc                 # Card module (entry point)
│   ├── pm.shinc                   # Project management module
│   │
│   ├── board/                     # Board subcommands
│   │   ├── __board_ls.shcmd       # List boards
│   │   ├── __board_mk.shcmd       # Create board
│   │   ├── __board_rm.shcmd       # Remove board
│   │   ├── __board_set.shcmd      # Configure board
│   │   ├── __board_cleanup.shcmd  # Cleanup
│   │   └── ...
│   │
│   ├── card/                      # Card subcommands
│   │   ├── __card_ls.shcmd        # List cards
│   │   ├── __card_mk.shcmd        # Create card
│   │   ├── __card_edit.shcmd      # Edit card
│   │   └── ...
│   │
│   └── column/                    # Column subcommands
│       ├── __column_ls.shcmd
│       └── ...
│
├── hooks/                         # Hook implementations
│   ├── pre/                       # Pre-execution hooks
│   │   ├── board/
│   │   │   ├── pre_board_cmd.shhook
│   │   │   └── rm/pre_board_rm.shhook
│   │   ├── card/
│   │   ├── column/
│   │   └── pm/
│   │
│   └── post/                      # Post-execution hooks
│       ├── board/mk/              # Hook after board creation
│       ├── card/
│       ├── column/
│       └── pm/
│
└── templates/                     # Board templates
    ├── board/
    │   ├── simple/                # Simple 3-column template
    │   ├── default/               # Standard template
    │   └── advanced/              # Advanced workflow
    └── pm/
        └── default/               # Default PM setup
```

---

## Core Concepts

### 1. **Modules**
A **module** is a bash function that handles a domain of functionality. Each module:
- Lives in `modules/{name}.shinc`
- Implements a main function matching the module name
- Dynamically discovers and dispatches subcommands
- Loads subcommand implementations from `modules/{name}/*.shcmd`

### 2. **Subcommands**
A **subcommand** is an individual command within a module, implemented as a bash function. For example:
- Module: `card`
- Subcommands: `ls`, `mk`, `edit`, `rm`, `mv`, etc.

Subcommand functions follow the naming convention: `__{module}_{subcommand}`

Example: `__card_mk()` is the "card make" subcommand.

### 3. **Libraries (.shinc files)**
**Shell include files** contain reusable functions and utilities:
- **decklib.shinc**: Core utilities (option parsing, module commands, help)
- **mdheaderlib.shinc**: Markdown header manipulation
- **colorcodes.shinc**: Terminal color support
- **deckhook.shinc**: Hook system implementation

### 4. **Hooks**
**Hooks** allow code to react to events without modifying core modules:
- **Pre-hooks**: Execute before a command runs
- **Post-hooks**: Execute after a command succeeds
- Hooks are implemented as shell scripts in `hooks/pre/` and `hooks/post/`

### 5. **Templates**
**Templates** provide pre-configured board structures:
- Located in `templates/board/{template-name}/`
- Contain predefined columns and default cards
- Can be selected when creating a new board

---

## Module System

### How Modules Are Loaded

1. **Entry Point** (`deck`):
   - Loads all `.shinc` library files from `git-deck/`
   - Loads all module `.shinc` files from `modules/`
   - Collects module names into an array

2. **Command Dispatch**:
   - Checks if the first argument matches a module name
   - Calls pre-hooks
   - Invokes the module function with remaining arguments
   - Calls post-hooks

3. **Subcommand Routing**:
   - Each module loads its `.shcmd` files from `modules/{name}/`
   - Discovers subcommands using function naming convention
   - Routes the subcommand to the appropriate function

### Example: Board Module Flow

```
git deck board ls
  ↓
deck_main() checks "board" is a module
  ↓
Calls: deck_hooks "pre" "3" "board" "ls"
  ↓
Calls: board() with arguments ["ls"]
  ↓
board() loads modules/board/*.shcmd files
  ↓
board() finds function __board_ls
  ↓
Calls: __board_ls()
  ↓
Calls: deck_hooks "post" "3" "board" "ls"
```

---

## Creating a New Module

This section provides a step-by-step guide to creating a new module called **`status`** (for displaying project status).

### Step 1: Create the Module Entry Point

Create `modules/status.shinc`:

```bash
#!/bin/sh
# status module: provides project status commands

status() {
    # Load subcommand files
    for module_cmd_file in "$MODULES_PATH"/${FUNCNAME[0]}/*.shcmd; do
        [ -e "$module_cmd_file" ] || continue
        . "$module_cmd_file"
    done

    # Discover subcommands dynamically
    local -A func_subcommands
    create_module_command_list func_subcommands "${FUNCNAME[0]}"

    # Dispatch to subcommand
    if [[ -n "${func_subcommands[$1]}" ]]; then
        "${func_subcommands[$1]}" "${@:2}"
        return $?
    else
        local usage="Usage: git deck ${FUNCNAME[0]} {$(IFS='|'; echo "${!func_subcommands[*]}")}"
        echo "Invalid ${FUNCNAME[0]} command. $usage"
        return 1
    fi
}
```

### Step 2: Create Subcommand Files

Create `modules/status/__status_show.shcmd`:

```bash
#!/bin/sh
# Show project status

__status_show() {
    # Parse options if needed
    local option_format='text'
    # ... option parsing logic ...

    # Implementation here
    # Access variables like:
    # - $PM_DIR: project management directory
    # - $DECK_DIR: deck directory
    
    echo "Showing project status..."
    # ... actual logic ...
}
```

Create `modules/status/__status_summary.shcmd`:

```bash
#!/bin/sh
# Display status summary

__status_summary() {
    # Implementation
    echo "Status summary..."
}
```

### Step 3: Create Help File

Create `modules/status.help`:

```
# Git-Deck Status Module

## Commands
- show: Display full project status
- summary: Show concise status summary

## Usage
git deck status show
git deck status summary
```

### Step 4: (Optional) Create Hooks

If your module needs to react to events, create hooks:

**`hooks/post/status/post_status_show.shhook`** (executes after `status show` runs):

```bash
#!/bin/sh
# Post-hook for status show command

# Your hook logic here
# This runs after the status show command completes
```

### Step 5: Test Your Module

Register and test:

```bash
# Ensure your module is in the correct location
# Then test:
git deck status help
git deck status show
git deck status summary
```

---

## Hook System

### How Hooks Work

Hooks are shell scripts that execute **before** or **after** a command runs. The hook system enables **extensibility without modifying core code**.

| Hook Type | When It Runs | Exit Code Behavior |
|-----------|----------|--------------------|
| **Pre-hook** | Before the command executes | If exit code ≠ 0, command is skipped |
| **Post-hook** | After the command succeeds | If exit code ≠ 0, error is reported |

### Hook File Naming & Location

| Hook Type | Path Pattern | Example |
|-----------|-----------|---------|
| Pre-hook | `hooks/pre/{module}/{subcommand}/pre_{module}_{subcommand}.shhook` | `hooks/pre/board/mk/pre_board_mk.shhook` |
| Post-hook | `hooks/post/{module}/{subcommand}/post_{module}_{subcommand}.shhook` | `hooks/post/card/mk/post_card_mk.shhook` |

### Creating a Hook

**Example: Pre-hook to validate before creating a board**

Create `hooks/pre/board/mk/pre_board_mk.shhook`:

```bash
#!/bin/sh
# Pre-hook: validate board name before creation

board_name="$1"

# Validation logic
if [[ -z "$board_name" ]]; then
    echo "Error: board name cannot be empty" >&2
    return 1
fi

if [[ ! "$board_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: board name contains invalid characters" >&2
    return 1
fi

return 0
```

### Hook Execution Flow

```
git deck board mk my-board
  ↓
deck_main() calls: deck_hooks "pre" "3" "board" "mk"
  ↓
Finds and executes hooks/pre/board/mk/*.shhook
  ↓
If any hook returns non-zero: abort and report error
  ↓
Otherwise: proceed with board() function
```

---

## Common Patterns & Best Practices

### 1. **Option Parsing**

Git-Deck uses the `parse_options()` function from `decklib.shinc` to handle both short and long options.

**Pattern:**

```bash
__card_mk() {
    local option_priority='normal'
    local option_assignee=''

    # Parse options: long options, short options, then arguments
    local output=$(parse_options "priority:assignee:labels:" "p:a:l:" "$@")
    if [[ $? -eq 0 ]]; then
        eval "$output"
        # Variables now available: option_priority, option_assignee, etc.
    else
        return 1
    fi

    # Use parsed options
    echo "Creating card with priority: $option_priority"
}
```

**Usage:**

```bash
git deck card mk --priority high --assignee john my-task
git deck card mk -p high -a john my-task
```

### 2. **Error Handling & Exit Codes**

Follow consistent error handling patterns:

```bash
__board_mk() {
    local board_name="$1"

    # Validate inputs
    if [[ -z "$board_name" ]]; then
        echo "Error: board name is required" >&2
        return 1
    fi

    # Check prerequisites
    if ! [ -d "$DECK_DIR" ]; then
        echo "Error: deck directory not initialized" >&2
        return 1
    fi

    # Attempt operation
    if ! mkdir -p "$DECK_DIR/$board_name"; then
        echo "Error: failed to create board directory" >&2
        return 1
    fi

    # Success
    echo "Board '$board_name' created successfully"
    return 0
}
```

### 3. **Consistent Output**

Use predictable output formats:

```bash
__board_ls() {
    local option_output='full'

    # ... parsing ...

    if [ "$option_output" == 'full' ]; then
        echo "Boards:"
    fi

    # Use simple, parseable output
    for board in "$DECK_DIR"/*; do
        if [ -d "$board" ]; then
            local name=$(basename "$board")
            echo " $name"
        fi
    done
}
```

### 4. **Accessing Shared Directories**

Git-Deck provides standard directory variables:

| Variable | Purpose | Example |
|----------|---------|---------|
| `GIT_ROOT` | Repository root | `/home/user/myproject` |
| `PM_DIR` | Project management | `$GIT_ROOT/.pm` |
| `DECK_DIR` | Deck storage | `$PM_DIR/deck` |
| `TEMPLATES_DIR` | Board templates | `$GIT_ROOT/.git/hooks/git-deck/templates` |
| `MODULES_PATH` | Modules directory | `$GIT_ROOT/.git/hooks/git-deck/modules` |

Use these in your subcommands:

```bash
__custom_ls() {
    # Access stored data
    for item in "$DECK_DIR"/*; do
        [ -e "$item" ] || continue
        # Process item
    done
}
```

### 5. **Using Library Functions**

Leverage common utilities from `decklib.shinc`:

```bash
# Create a command list
create_module_command_list my_commands "mymodule"

# Show help from a file
cat_help "$MODULES_PATH/mymodule.help"

# Parse options
parse_options "long-opt:" "s" "$@"
```

### 6. **Naming Conventions**

Follow these naming patterns for consistency:

| Element | Pattern | Example |
|---------|---------|---------|
| Module function | `{module-name}()` | `board()`, `card()` |
| Subcommand function | `__{module}_{subcommand}()` | `__card_mk()`, `__board_ls()` |
| Local variables | `lowercase_with_underscores` | `board_name`, `card_id` |
| Options (from parsing) | `option_{name}` | `option_priority`, `option_assignee` |
| Libraries | `{purpose}.shinc` | `decklib.shinc` |
| Help files | `{module}.help` | `board.help` |

### 7. **Defensive Programming**

Always validate inputs and check preconditions:

```bash
__card_mv() {
    local card_name="$1"
    local target_column="$2"

    # Check inputs
    [[ -z "$card_name" ]] && echo "Error: card name required" >&2 && return 1
    [[ -z "$target_column" ]] && echo "Error: target column required" >&2 && return 1

    # Check prerequisites
    [[ ! -d "$DECK_DIR" ]] && echo "Error: deck not initialized" >&2 && return 1

    # Find card and validate it exists
    local card_path=""
    # ... search logic ...

    [[ -z "$card_path" ]] && echo "Error: card not found" >&2 && return 1

    # Proceed with operation
}
```

