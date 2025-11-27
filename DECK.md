---
Title: Project management
Description: plans and project management sheets
Date: 
Robots: noindex,nofollow
Template: index
---

# Git hooks

Abbreviations
> * PM Product Milestone
> * MD Milestone division
> * SD Subdivision

## Analyzing all parts

|#|Part|Details|Total Duration|Status|
|:-|:-|:-|:-|:-|
|1|[Develop](%base_url%/pm#Develop_timeplan)|2025-11-26 - 2025-11-26|5 hours|DONE|
|2|[Maintenance](%base_url%/pm#Maintenance_timeplan)|2025-11-26 -|- hours|ONGOING|
|:-|:-|:-|::||


## Develop timeplan

```mermaid
gantt
    section MD1
    SD1 - Git hooks scripts              :done,md1des1, 2025-11-24,2d
    SD2 - Update the repo itself with deck              :done,md1des2, after md1des1,1d
```

## Maintenance timeplan

```mermaid
gantt
    section MD1
    SD1 - Fix issues - Links                     :done,md2des1, 2025-11-26,1d

```

# Stories/cards MD1 - Develop

## 48-002
### Add hooks ![status](https://img.shields.io/badge/status-DONE-brightgreen)
<details>
    <summary>Details</summary>

>The goal of this card is to update the local repo itself with hooks.
>It also aims to add a deck file to the repo
>
>### DOD  (definition of done):
>Hooks files are added to the local repo.
>A Deck file is created for the progect
>
>### TODO :
>- [x] 1. Add git hooks' scripts
>- [x] 2. Updated Deck path
>- [x] 3. Add a deck file to the repo
>- [x] 4. Update time plan
>
>### Reports :
>* 
>
>### Steps to test and debugging:
>- [] 1.
>
>### References :
>* []()
</details>

# Stories/cards MD1 - Maintenance

## 48-003
### Fix links issues ![status](https://img.shields.io/badge/status-DONE-brightgreen)
<details>
    <summary>Details</summary>

>It seems the link created by hooks does not work. The goal of this card is to find the problem and fix it.
>
>### DOD  (definition of done):
>Links created by git hook scripts work
>
>### TODO :
>- [x] 1. Find wath the issue is
>- [x] 2. Fix it
>- [x] 3. Document findings
>- [x] 4. Update time plan
>
>### Reports :
>* The problem was on variable definations
>
>### Steps to test and debugging:
>- [] 1.
>
>### References :
>* []()
</details>

## 48-004
### update README ![status](https://img.shields.io/badge/status-DONE-brightgreen)
<details>
    <summary>Details</summary>

>The goal of this card is to update README.
>
>### DOD  (definition of done):
>README is updated.
>
>### TODO :
>- [x] 1. README is updated with a linke to this file DECK
>
>### Reports :
>*
>
>### Steps to test and debugging:
>- [] 1.
>
>### References :
>* []()
</details>

## 48-005
### Goal : update README ![status](https://img.shields.io/badge/status-DONE-brightgreen)
<details>
    <summary>Details</summary>

>>The goal of this card is to update README.
>>
>>### DOD  (definition of done):
>>README is updated.
>>
>>### TODO :
>>- [x] 1. README is updated with a linke to this file DECK
>>
>>### Reports :
>>*
>>
>>### Steps to test and debugging:
>>- [] 1.
>>
>>### References :
>>* []()
</details>