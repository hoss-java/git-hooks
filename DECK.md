---
Title: Git-hooks
Description: plans and project management sheets
Date: 
Robots: noindex,nofollow
Template: index
---

# Git-hooks

## Analyzing all parts

|#|Part|Details|Total Duration|Status|
|:-|:-|:-|:-|:-|
|1|-|-|-|-|-|
|:-|:-|:-|::||


## Timeplan

```mermaid
gantt
    section git-deck
```

# 1 - git-deck

## 001-0001
> **Fix github yaml issues** ![status](https://img.shields.io/badge/status-DONE-brightgreen)
> <details >
>     <summary>Details</summary>
> 
> # DOD (definition of done):
> Github workflow YAML gets working.
> 
> # TODO:
> - [x] 1. Find out what is the issue
> 
> # Reports:
> * It seams the script is run but no output is crated!
> * It seems the problem is the way that github run a command
> * There is no accress to remote via virtual machin that github runs
> </details>

## 001-0003
> **Work around Github api.** ![status](https://img.shields.io/badge/status-DONE-brightgreen)
> <details >
>     <summary>Details</summary>
> 
> # DOD (definition of done):
> The goal of this card is to demonstrate how to use the GitHub API to synchronize tasks between Git-Deck boards and GitHub Kanban boards.
> 
> # TODO:
> - [x] 1. Understand Github API
> - [x] 2. How to to use it to automate tasks
> - [x] 3. Work around how to develop a two ways sync between git-deck and Github kanban board
> 
> # Reports:
> * All findings was written done in a file named `github_api_spike.md`
> </details>

## 001-0004
> **Update git-deck-tools and clean up not used files.** ![status](https://img.shields.io/badge/status-DONE-brightgreen)
> <details >
>     <summary>Details</summary>
> The goal of this card is to clean up scripts and YAML files,
> 
> # DOD (definition of done):
> * All files are pushed.
> 
> # TODO:
> - [x] 1. Remove sync part from git-deck-tools.sh
> - [x] 2. Update YAML files and remove sync to gh boards parts
> - [X] 3. Remove test tokens from github
> - [x] 4. Test the main Github action to create DECK.md works fine
> 
> # Reports:
> *
> </details>

## 001-0002
> **Update git-hooks to check titles with cards** ![status](https://img.shields.io/badge/status-NOT--STARTED-lightgrey)
> <details >
>     <summary>Details</summary>
> 
> # DOD (definition of done):
> 
> # TODO:
> - [] 1.
> 
> # Reports:
> *
> </details>

## 001-0006
> **Develop a simple installer for git-deck** ![status](https://img.shields.io/badge/status-NOT--STARTED-lightgrey)
> <details >
>     <summary>Details</summary>
> The goal of this card is to code a simple script to install and setup git-deck
> 
> # DOD (definition of done):
> An installer is developed and tested.
> A README is added as a user guide.
> 
> # TODO:
> - [] 1.
> 
> # Reports:
> *
> </details>

## 001-0005
> **Connect git-deck and git hooks message.** ![status](https://img.shields.io/badge/status-ONGOING-yellow)
> <details open>
>     <summary>Details</summary>
> The goal of this card is to improve gut-deck integrations with git.
> 
> # DOD (definition of done):
> Git message hook check cards before commit.
> Auto complatations suggest git messages based on ONGOING card.
> A new option to ignore message format is added to git hooks.
> All findings are documented
> 
> # TODO:
> - [] 1. Add check cards' ID to git message hooks
> - [] 2. Add option to skip commit message format
> - [] 3. Auto-complet for commit messages
> - [] 4. Auto add git-deck changes
> - [] 5. Add auto-tag
> - [] 6. Add other items to header (creator, user, date, start-time, done-time...)
> - [] 7. Auto timetracker
> - [] 8. Plan to make it possible to use as Scrum board
> 
> # Reports:
> *
> </details>
