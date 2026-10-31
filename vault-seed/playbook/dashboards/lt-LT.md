---
type: dashboard
title: "Mano savaitė"
created: {{date:YYYY-MM-DD}}
status: active
tags: [dashboard]
summary: "Vienas puslapis, kuris užsipildo pats: Jūsų paskutinės 7 dienos, tikslai ir tai, kas laukia gautuosiuose."
---
# Mano savaitė
Šis puslapis užsipildo pats. Jo keisti niekada nereikia. Kai pridedate užrašų, sąrašai žemiau patys pailgėja.
Jei sąrašas tuščias, ten dar nieko nėra.

## Jūsų paskutinės 7 dienos
Po vieną eilutę kiekvienai dienai, kai pasisveikinome ryte: kaip jautėtės ir diena keliais žodžiais.

```dataview
TABLE WITHOUT ID file.link AS "Diena", mood AS "Nuotaika", energy AS "Energija", summary AS "Trumpai"
FROM "01-Dienorastis"
WHERE type = "daily" AND file.day >= date(today) - dur(6 days)
SORT file.name DESC
```

## Jūsų tikslai
Visi tikslai, prie kurių dabar dirbate.

```dataview
TABLE WITHOUT ID file.link AS "Tikslas", summary AS "Trumpai"
FROM "02-Tikslai"
WHERE type = "goal" AND status = "active"
SORT file.name ASC
```

## Laukia gautuosiuose
Tai, ką greitai išsaugojote. Kartą per savaitę kartu sudedame į tinkamus aplankus.

```dataview
LIST summary
FROM "00-Gautieji"
WHERE type != "folder-guide"
SORT file.ctime DESC
LIMIT 10
```
