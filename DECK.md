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
> The goal of this card is to improve gut-deck integration with git.
> 
> # DOD (definition of done):
> Git message hook check cards before commit.
> Auto complete git messages suggestions based on ONGOING card.
> A new option to ignore message format is added to git hooks.
> All findings are documented
> 
> # TODO:
> - [x] 1. Add check cards' ID to git message hooks
> - [x] 2. Add option to skip commit message format
> - [ ] 3. Auto-complete for commit messages
> - [ ] 4. Auto add git-deck changes
> - [ ] 5. Add auto-tag
> - [ ] 6. Add other items to header (creator, user, date, start-time, done-time...)
> - [ ] 7. Auto time tracker
> - [ ] 8. Plan to make it possible to use as Scrum board
> - [x] 9. Add a flag to enable/disable adding changeId
> 
> # Reports:
> * Both `commit-msg-format.shinc` and `commit-msg-decklink.shinc` were updated
> * Now It support some new directions such as `--nocheck` to skip message format check
> * It also updated to look for settings inside of git root folder, it looks for a file named `.gitdefault`
> * `.gitdefault` has a format as below
> >```
> ># Card link pattern
> >deckLinkFlag=true
> >deckLinkAddr="https://github.com/<GITOWNER/ORG>/$(git rev-parse --show-toplevel)/blob/main
> >DECK.md#%BOARDID%-%CARDID%"
> >
> ># Message pattern
> >messagePattern='['[bB]*[0-9]-[cC]*[0-9]']'*
> >messagePatternErrMsg="A message should be started with a pattern like [B<board-id>-C<card-id>]"
> >
> ># Add change-Id
> >gerritChangeIdFlag=true
> >```
> > * **OBS!** in the file above the link address and other settings can be updated, the new hook support some variables such as `%BOARDID%` and `%CARDID%` that will be replaced when they are created through a commit.
> > * By default the hook check a git message (the 1st message) the pattern with the pattern defined in `.gitdefault` (`messagePattern`), if it's not matched , it will show an error and ask to fix it. To skip the pattern check, a direction named `--nocheck` should be passed to the commit via 2nd or grater message for example
> >>```
> >>git commit -m "my commit message without pattern" -m "--nocheck"
> >>```
> > * Adding change-Id (used by gerrit commits) can be skipped by passing `--nochangeid` as 2nd or later message
> >>```
> >>git commit -m "my commit message without pattern" -m "--nochangeid"
> >>#or skipping both pattern check and adding change-Id
> >>git commit -m "my commit message without pattern" -m "--nochangeid" -m "--nochangeid"
> >>```
> * There was some challenge to update git hooks, git hooks are `sh` based not `bash` and many statements that work on bash do not work on `sh`. For example it took a while to find a solution to read a multi-lines variable line-by-line though a loop.
> </details>
