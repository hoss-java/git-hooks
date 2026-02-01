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

## 001-0002
> **Update and Enhance Git Hooks for Better Optimization and Readability.** ![status](https://img.shields.io/badge/status-DONE-brightgreen)
> <details >
>     <summary>Details</summary>
> The goal of card to improve an optimize the current code for all git-deck parts.
> 
> # DOD (definition of done):
> `card`, `column`, `board` and pm are optimized.
> `deck` is support an auto completion function to use/call from `git-deck-completion`.
> A new auto completion to help to find git commit title is added to to `git-deck-completion`.
> 
> # TODO:
> - [x] 1. Remove or Unify Repeated Blocks in `card`
> - [x] 2. Remove or Unify Repeated Blocks in `column`
> - [x] 3. Remove or Unify Repeated Blocks in `board`
> - [x] 4. Improve variable usages (local, global) in all code's files
> - [x] 5. Add a new method to predicate args/params (will be used by `git-deck-completion`)
> - [x] 6. Update `deck` to support changes
> - [x] 7. Add a hook methods to support events' trapper
> - [x] 8. Organize file structure if it needs
> - [x] 9. Rename column status file to a more generic such as setting
> - [x] 10. add color to column settings
> - [x] 11. highlight active board/column and card with a color
> - [x] 12. Update installer
> 
> # Reports:
> * Now commands are modular and can be added new commands more structured
> * All parts were coded to make it fully modular
> * Now the main functions support share libraries
> * Now it supports hook for all commands, hooks can be defined for before and after running a command
> * All files were organized to make it more clear
> * Several bugs were fixed
> * Output was colorized
> * A new column settings was implemented
> * All templates were updated to support colors
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

## 001-0006
> **Develop a simple installer for git-deck** ![status](https://img.shields.io/badge/status-DONE-brightgreen)
> <details >
>     <summary>Details</summary>
> The goal of this card is to code a simple script to install and setup git-deck
> 
> # DOD (definition of done):
> An installer is developed and tested.
> A README is added as a user guide.
> 
> # TODO:
> - [x] 1. Reorganize files
> - [x] 2. Develop a simple installer
> 
> # Reports:
> * Files reorganize to separate hook files and other files, hooks now moved to folder name hooks
> * `github_api_spike.md` was moved to root of the repo
> * `git-deck` templates were copied inside of `hooks/git-deck`
> > * **OBS!** It needs to update `git-deck` script to look for templates inside of the `hooks/git-deck`
> * A simple installer was developed to install git hooks and git-deck files
> > * To use the installer it needs to change the current path to the git folder that is planed to to use git hooks and got-deck
> > * The installer add almost all files to `.git/hooks` in the current git folder.
> > * A file name `.gitdefault` is copied to the git root folder
> > * A file named `git-deck-completion.sh` is copied to the HOME folder of the current user and then the file is sourced via `.bashrc` and `.bash_profile`
> </details>

## 001-0007
> **Improve installer to support add github action files.** ![status](https://img.shields.io/badge/status-NOT--STARTED-lightgrey)
> <details >
>     <summary>Details</summary>
> The goal of this card is to improve the installer to support install github action files.
> 
> # DOD (definition of done):
> The installer has an option to install/copy guthub action files to repos
> 
> # TODO:
> - [ ] 1.
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
> - [x] 3. Auto-complete for commit messages
> - [ ] 4. Auto add git-deck changes
> - [ ] 5. Add auto-tag
> - [x] 6. Add other items to header (creator, user, date, start-time, done-time...)
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

## 001-0008
> **Fix auto completion bug.** ![status](https://img.shields.io/badge/status-ONGOING-yellow)
> <details open>
>     <summary>Details</summary>
> The goal of this card is to completion bugs.
> 
> # DOD (definition of done):
> It works for both commit and deck.
> 
> # TODO:
> - [x] 1. Fix the conflict between commit and deck.
> - [ ] 2. Find out why only on git root , completions work
> 
> # Reports:
> *
> </details>

## 001-0009
> **Improve git hooks** ![status](https://img.shields.io/badge/status-ONGOING-yellow)
> <details open>
>     <summary>Details</summary>
> The goal of this card is to improve Git hooks by separating the directives collector from the message formatter.
> 
> # DOD (definition of done):
> Directives collector has its own script.
> All hooks and scripts are updated to use the new Directives collector.
> 
> # TODO:
> - [x] 1. Move Directives collector from commit-msg-format.shinc to a new shinc (commit-msg-directives.shinc)
> - [x] 2. Update commit-msg-format.shinc and commit-msg to use commit-msg-directives.shinc
> - [x] 3. Add this system to other hooks such as pre-commit
> - [x] 4. Update other files/script if needed
> 
> # Reports:
> *
> </details>
