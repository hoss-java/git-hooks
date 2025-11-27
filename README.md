# Git hooks
A set of git hook scripts to make commits more structured

**Deck board** -> https://github.com/hoss-java/gitthooks/blob/main/DECK.md

## What git-hooks are
Git-hooks are a set of scripts that check commit messages to be sure they follow a structure that can be tracked via a document file.

The description written about a commit can always include a link to the commit itself. But from the commit side, it is not possible to access the documented explanation about the commit. GitHooks essentially make the connection between the documentation and the commit itself two-ways by assigning a reference number to the commit. They also add a link to comments to provide access to documents parts directly from the commit.

## How it works
Git hooks check all commit messages to be sure messages start with a pattern like [W<week-number>-C<card-number>].
It means that a commit command with activated git hooks should be look like below. If a commit message is not started with the pattern, hook scripts shows an error and ask to use a valid pattern. 

```
git commit -m "[W47-001] commit message/description"
```

A format commit message is processed by by the git hooks to create a link to a related document (a markdown file) and adding link to commit.
Given that a task management system (such as Deck) is not available in the free version of GitHub, a Markdown file has been used instead to manage stories/commits. In other words a markdown file is defined for the git hooks and the hooks add a link to a tag (based on commit parssed message) in the markdown file to the commit.

As an example to understand how it works, assume the link to the Markdown file is https://github.com/hoss-java/lessons/blob/main/DECK.md. Using [w47-001] as the prefix for a commit message, add https://github.com/hoss-java/lessons/blob/main/DECK.md#47-001 as the reference link in the commit. It means the link tries to find `47-001` as a tag in `DECK.md`

* DECK.md
>```
>.
>.
>## 47-001
> Task description and explanation
>.
>.
>```

## How to install and activating git hooks
This repository contains 6 files and a readme and a DECK sample file
> * `commit-msg`
> * `commit-msg-decklink.shinc`
> * `commit-msg-format.shinc`
> * `deckpath.shinc`
> * `msg-check.sh`
> * `pre-commit`

1. Clone the repo
2. Copy all files above to `.git/hooks` , in side of repositories that you want use git hooks
3. Upen `.git/hooks/deckpath.shinc` and update the path of the deck file (`deckAddr`).
>```
>#
># File name : deckpath.shinc
># Used by commit-msg
>#
># Description :
># -----------------------------------------------------
># Define the deck file path
>#
># The script is developed to run from commit-msg as a git hook.
>#
>#
># 2025 hossjava@osxx.com
>
>deckAddr=https://github.com/hoss-java/lessons/blob/main/DECK.md
>```
4. Create or add a file to the repo in the same address that you define in `.git/hooks/deckpath.shinc`
5. For each commit add a section with a title that follows hook message pattern.
> `https://github.com/hoss-java/lessons/blob/main/DECK.md`
>>```
>>.
>>.
>># Commit 'message 1' with a commit message ´[w47-001] message 1´
>>## 47-001
>>.
>>.
>>
>># Commit 'message 2' with a commit message ´[w47-002] message 2´
>>## 47-002
>>.
>>.
>>```
6 . Use `DECK.md.sample` as a sample for `DECK.md`
7. To access to the link added by git hooks script, under commit destcription (click on the three dots `...` in the right site of the commit title) looks for `Deck-Link`)