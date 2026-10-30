---
type: dashboard
title: "Mi semana"
created: {{date:YYYY-MM-DD}}
status: active
tags: [dashboard]
summary: "Una página que se llena sola: tus últimos 7 días, tus metas y lo que espera en tu carpeta de entrada."
---
# Mi semana
Esta página se llena sola. No tienes que cambiarle nada. Cuando agregas notas, las listas de abajo crecen solitas.
Si una lista sale vacía, es que todavía no hay nada ahí.

## Tus últimos 7 días
Una línea por cada día que nos dimos los buenos días: cómo te sentiste y el día en pocas palabras.

```dataview
TABLE WITHOUT ID file.link AS "Día", mood AS "Ánimo", energy AS "Energía", summary AS "En corto"
FROM "01-Diario"
WHERE type = "daily" AND file.day >= date(today) - dur(6 days)
SORT file.name DESC
```

## Tus metas
Cada meta en la que estás trabajando ahorita.

```dataview
TABLE WITHOUT ID file.link AS "Meta", summary AS "En corto"
FROM "02-Metas"
WHERE type = "goal" AND status = "active"
SORT file.name ASC
```

## Lo que espera en tu carpeta de entrada
Cosas que guardaste rápido. Una vez a la semana las ponemos en su carpeta.

```dataview
LIST summary
FROM "00-Entrada"
WHERE type != "folder-guide"
SORT file.ctime DESC
LIMIT 10
```
