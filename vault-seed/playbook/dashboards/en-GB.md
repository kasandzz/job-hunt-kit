---
type: dashboard
title: "My week"
created: {{date:YYYY-MM-DD}}
status: active
tags: [dashboard]
summary: "One page that fills itself in: your last 7 days, your goals and what is waiting in your inbox."
---
# My week
This page fills itself in. You never need to change it. When you add notes, the lists below grow by themselves.
If a list is empty, there is nothing there yet.

## Your last 7 days
One line for each day we said good morning: how you felt, and the day in a few words.

```dataview
TABLE WITHOUT ID file.link AS "Day", mood AS "Mood", energy AS "Energy", summary AS "In short"
FROM "01-Daily"
WHERE type = "daily" AND file.day >= date(today) - dur(6 days)
SORT file.name DESC
```

## Your goals
Every goal you are working on now.

```dataview
TABLE WITHOUT ID file.link AS "Goal", summary AS "In short"
FROM "02-Goals"
WHERE type = "goal" AND status = "active"
SORT file.name ASC
```

## Waiting in your inbox
Things you saved quickly. Once a week we put them in the right folder together.

```dataview
LIST summary
FROM "00-Inbox"
WHERE type != "folder-guide"
SORT file.ctime DESC
LIMIT 10
```
