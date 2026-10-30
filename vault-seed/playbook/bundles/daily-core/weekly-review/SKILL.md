---
name: weekly-review
description: Weekly review of the last 7 daily notes (wins, patterns in mood and energy, goal progress) ending with next week's top 3, saved as a week note. Then it tidies the inbox folder, and once a month checks the "how to talk to me" rules. Triggers: "weekly review", "how was my week", "revisión semanal", "cómo me fue esta semana".
---

## Steps
1. **Who and when.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list. Work out today's date and its ISO week number (`<yyyy>-W<nn>`, two digits) in the language profile's time zone. On a Monday, the week being reviewed is the one that just ended: use yesterday's ISO week number.

2. **Already done?** If `week-<yyyy>-W<nn>.md` exists in the `daily` folder with `status: open`, it is an empty week page they opened from Obsidian (the Periodic Notes add-on makes it from `_templates/week`): carry on below and fill that same note in at step 8, setting `status: done`; never start a second note for the same week. If it exists with any other status, read it, show its top 3 and ask in a question box: en-GB "You already looked back at this week. Here are your top 3: <top 3>. What would you like?" es-MX "Ya revisamos esta semana. Estas son tus 3 prioridades: <top 3>. ¿Qué quieres hacer?" Options: **Keep it as it is (Recommended)** / **Add to it** / **tell me more** (es-MX **Dejarla así (Recomendado)** / **Agregarle algo** / **cuéntame más**). Add to it = continue below and append; never start a second note for the same week. Keep it = go to step 9.

3. **Read the week.** Read the daily notes from the last 7 days in the `daily` folder (`<yyyy-mm-dd>.md`). Missing days are fine; never comment on them.

4. **Wins.** Up to 5 short lines from their "Wins", ticked Top 3 items and goal progress. Lead with the best one.

5. **Patterns.** 2-3 lines on mood, energy and sleep across the week, from `mood:` and `energy:` and anything they wrote. Kind and plain, for example "Energy was higher on the days you walked". Only say what the notes show; if there is too little, say so in one line.

6. **Goals.** One line per active goal in the `goals` folder: progress this week from its "Progress log", or "no update this week" said gently.

7. **Next week's top 3.** Suggest 3 from goals, carried-over items and patterns. Question box: en-GB "For next week, how about these 3? <the 3>" es-MX "Para la próxima semana, ¿qué tal estas 3? <the 3>" Options: **These 3 (Recommended)** / **Change one** / **tell me more** (es-MX **Estas 3 (Recomendado)** / **Cambiar una** / **cuéntame más**).

8. **Save.** Write `week-<yyyy>-W<nn>.md` in the `daily` folder:
   ```
   ---
   type: weekly-review
   title: "week-<yyyy>-W<nn>"
   created: <yyyy-mm-dd>
   status: done
   tags: [weekly-review]
   summary: "<one line>"
   ---
   ```
   then the headings Wins, Patterns, Goals and Next week's top 3, translated into their language. Confirm in one line where it was saved.

9. **Tidy the inbox.** The inbox is where quick saves land. Once a week, help each note find its home.
   a. With the Glob tool, list the `.md` notes in the `inbox` folder. Leave out the "what goes here" note (`type: folder-guide`). If there are none, skip to step 10 and say nothing.
   b. For each note, read its `type:`, `title:` and `summary:` and pick the best folder from the folder table, the same way `save-this` does: link -> `learning` (a book -> `books`, a video -> `videos`), recipe -> `home`, person -> `people`, job -> `jobs`, anything about a goal -> `goals`. An idea with no better home stays in the inbox: leave it out of the list.
   c. If nothing needs moving, skip to step 10. Otherwise show one question box that holds the whole list, one short line per note: en-GB "Your inbox has <n> notes that have a better home. <title> -> <folder>, one line each. Shall I move them?" es-MX "Tu bandeja tiene <n> notas que tienen un mejor lugar. <title> -> <folder>, una por línea. ¿Las muevo?" Options: **Move them all (Recommended)** / **Pick which** / **Leave them** / **tell me more** (es-MX **Muévelas todas (Recomendado)** / **Escoger cuáles** / **Déjalas** / **cuéntame más**).
      - Pick which = one more box with several answers allowed, up to 4 notes per box, then move only the ticked ones.
      - Leave them = skip to step 10.
      - Test mode: use the next answer.
   d. Say once, before moving: en-GB "A box may pop up asking if I can move these notes. Please click Allow." es-MX "Puede salir un aviso pidiendo permiso para mover estas notas. Dale clic en Permitir."
   e. Move them with one PowerShell command, one `Move-Item -LiteralPath "<old path>" -Destination "<new folder>\<same file name>"` per note, joined with `;`. If a note with that name is already in the new folder, add `-2` to the new name (`-3` if that is taken too); never overwrite. If `playbook/state/obsidian-tool.md` says `cli: on`, you may move each note with `obsidian move path="<old path>" to="<new folder>"` instead, as `playbook/obsidian-tool.md` describes (it keeps the links between notes working); if that fails, use `Move-Item`.
   f. Then, for each moved note, use the Edit tool to add one line `sorted: <yyyy-mm-dd>` at the end of its top block (just before the closing `---`). This edit is what makes the backup save the note in its new place.
   g. Confirm in one line: en-GB "Done. <n> notes moved to their folders." es-MX "Listo. Moví <n> notas a sus carpetas."

10. **How I talk to you (once a month).** Read `playbook/state/rules-checked.md`.
   - If it does not exist: write it with one line, `checked: <today, yyyy-mm-dd>`, and skip this step (the first check comes in about a month).
   - If `checked:` is fewer than 28 days ago: skip this step.
   - Otherwise read the `## How to talk to me` section of `CLAUDE.md` at the notebook root, and show a question box with those lines retold in plain words: en-GB "Once a month I check how I talk to you. Right now I: <the lines, as short plain sentences>. Is that still right?" es-MX "Una vez al mes reviso cómo te hablo. Ahorita yo: <the lines, as short plain sentences>. ¿Sigue estando bien?" Options: **Keep it (Recommended)** / **Change one** / **tell me more** (es-MX **Así déjalo (Recomendado)** / **Cambia una** / **cuéntame más**).
   - Change one = one question box with each line as an option, plus **tell me more** for something new. Then ask what it should say instead, in their words. Use the Edit tool to change only that line (or add the new line) under `## How to talk to me`. Never touch any other part of `CLAUDE.md`. Read the new line back in one sentence.
   - Test mode: use the next answer.
   - Last, write `playbook/state/rules-checked.md` again with `checked: <today>`.

11. **Limit question (backup only, Sundays only).** Only if today is Sunday AND `playbook/state/limit-hits.log` does not exist (the automatic counter normally does this job). Ask one question box: "This week, did you see a message saying you'd reached your limit?" ("Esta semana, ¿te salió un mensaje de que llegaste a tu límite?"). Options: **No (Recommended)** / **Yes, a few times** / **tell me more** (es-MX **No (Recomendado)** / **Sí, unas cuantas veces** / **cuéntame más**). Yes = write `playbook/state/suggest-upgrade.flag` containing one line, today's date. Say nothing more about it now; the Monday check-in handles it.

## Never
- Never invent a win, a pattern or a number that is not in their notes.
- Never judge or guilt them about missed days, low moods or slow goals.
- Never ask the limit question if `limit-hits.log` exists, or on any day but Sunday.
- Never delete or overwrite a note. Never move a note they did not agree to move, and never move anything out of any folder except the inbox.
- The only files you may create are the week note, `playbook/state/rules-checked.md` and `suggest-upgrade.flag`. The only edits you may make are the `sorted:` line on moved notes and the `## How to talk to me` lines in `CLAUDE.md` they agreed to.
- Never use tech words from the language profile's "Avoid" list.
