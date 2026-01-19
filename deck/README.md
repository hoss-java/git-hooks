# Git-Deck

The **Git-Deck** is a powerful tool designed to manage your Kanban boards directly through Git. With features that allow you to create, edit, and manage boards, columns, and cards, it integrates seamlessly with your existing workflow.

## Purpose
The Git-Deck allows you to perform various operations related to Kanban boards, making it easier to track tasks and manage projects efficiently. 

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