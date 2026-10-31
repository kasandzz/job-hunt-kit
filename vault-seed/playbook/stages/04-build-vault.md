# Stage 4: Build the notebook

## Goal
Turn the interview into their notebook: folders in their language (each with a short "what goes here" note), an "about me" note, one note per goal and per person, a "my week" page that fills itself in, ready-made note templates, and their personal rules file. The user sees their own life reflected back, tidy and private, and is never asked to allow anything.

## Steps
Before you start: read `playbook/state/profile.json`, the `## Folder names` table in `playbook/profiles/language-<language>.md`, and `playbook/state/interview.md`. Folders below are named by key (`home`, `goals`, ...); always use the folder name from that table. Tell them in one line: en-GB "Now I'll build your notebook from what you told me. It takes a minute or two." es-MX "Ahora armo tu cuaderno con lo que me contaste. Tarda uno o dos minutos."
Rules for every note in this stage:
- Write each file with the file-writing tool. Never use a shell command to make a folder, copy a file or write a file: a permission box would worry them, and the backup only notices files written with the file-writing tool.
- File names: `lowercase-kebab-case.md`, no accents, for example `learn-to-swim.md`, `tia-lupe.md`.
- Write the note text in their language. Keep the top block keys (`type`, `title`, `created`, `status`, `tags`, `summary` and the type fields) in English; fill `created` with today's date (YYYY-MM-DD) and `summary` with one line.
- Replace `{{title}}` and `{{date:YYYY-MM-DD}}` with real values when you make a note from a template.
- Never write passwords, bank or card numbers, or ID numbers into any note.

1. **Folders.** Writing a note into a folder makes the folder, so no shell command is needed. For each row of the `## Folder names` table, in table order, write one short note inside that folder with the file-writing tool: `<folder>/what-goes-here.md` (es-MX: `<folder>/que-va-aqui.md`). If that note is already there (a resumed sitting), leave it as it is. Each note is exactly:
   ```
   ---
   type: folder-guide
   title: "<What goes here / Qué va aquí>"
   created: <yyyy-mm-dd>
   status: guide
   tags: [folder-guide]
   summary: "<the sentence for this folder>"
   ---
   # <What goes here / Qué va aquí>
   <the sentence for this folder>
   ```
   The sentence for each folder key:
   | key | en-GB | es-MX |
   |---|---|---|
   | inbox | Quick things you save, like an idea or a link, before they have a home. Once a week we put them in the right folder. | Cosas que guardas rápido, como una idea o un enlace, antes de tener su lugar. Una vez a la semana las ponemos en su carpeta. |
   | daily | One note for each day: how you feel, your 3 most important things and your wins. Your look back at each week goes here too. | Una nota por cada día: cómo te sientes, tus 3 cosas más importantes y tus logros. Aquí también va el repaso de cada semana. |
   | goals | One note for each goal: why it matters to you, and each small step you take. | Una nota por cada meta: por qué te importa y cada pasito que das. |
   | people | One note for each person who matters to you: birthdays and things to remember. | Una nota por cada persona importante para ti: cumpleaños y cosas que recordar. |
   | learning | Things you are learning. Inside are three folders: books, videos, and answers I look up for you. | Lo que estás aprendiendo. Adentro hay tres carpetas: libros, videos y respuestas que busco para ti. |
   | books | One note for each book: what each part is about, words you liked, and questions to talk about. | Una nota por cada libro: de qué trata cada parte, frases que te gustaron y preguntas para platicar. |
   | videos | Short write-ups of videos you asked me about, each with one small thing to try. | Resúmenes cortos de los videos que me pediste, cada uno con una cosa pequeña para intentar. |
   | research | Answers I looked up for you, with where each fact came from. | Respuestas que busqué para ti, con de dónde salió cada dato. |
   | jobs | Jobs you like the look of, your CV, your letters and your interview practice. | Vacantes que te interesan, tu CV, tus cartas y tu práctica de entrevistas. |
   | home | Notes about you and your home life: the note about you, your ideas list, your week page and things like recipes. | Notas sobre ti y tu vida en casa: la nota sobre ti, tu lista de ideas, tu página de la semana y cosas como recetas. |
   | projects | One note for each bigger thing you are working on: what it is for, what "done" looks like, and the next small step. | Una nota por cada cosa grande en la que andas: para qué es, cómo se ve cuando ya quedó, y el siguiente pasito. |
   | howto | Step-by-step notes for things you do again and again, so you never have to remember how. | Notas paso a paso de cosas que haces una y otra vez, para que nunca tengas que acordarte de cómo. |
   | archive | Old notes you have finished with. Nothing is ever thrown away; it just rests here. | Notas viejas que ya terminaste. Nunca se tira nada; aquí solo descansan. |
   Then write `playbook/state/folders.md` listing each folder, one per line. Stage 6 uses this list.

2. **About me.** Make `about-me.md` in the `home` folder from `playbook/templates/about-me.md`. Translate the headings into their language. Under each heading, write 2-5 warm sentences in the second person ("You love early mornings in the garden...") from the matching `## Area N` in `interview.md`, using their own words where you can. If an area says `Skipped by choice.`, write one kind line (en-GB "We can talk about this whenever you like." es-MX "Podemos platicar de esto cuando quieras.").
   - Health and worries: write only what they said they want help with, gently. Never add anything they did not say.

3. **Goals.** For each goal from `## Area 3`, make one note in the `goals` folder from `playbook/templates/goal.md`. Fill `title`, `horizon` (`year` or `month`), "why it matters" and "first step" from their answers, and the first progress line with today's date. Headings in their language. If area 3 has no clear goal, make one note from their main dream in area 2, with `horizon: year`.

4. **People.** For each named person from `## Area 6`, make one note in the `people` folder from `playbook/templates/person.md`, named after the person (`ruth.md`, `tia-lupe.md`). Fill `relationship`, `birthday` (YYYY-MM-DD, or `--MM-DD` if the year is unknown, or empty) and "things to remember".
   - Never write health details, worries or anything from areas 4 and 5 into a person note, even about that person.

5. **Templates, notebook settings and the week page.** The installer already copied each file in `playbook/templates/` except `rules-CLAUDE.md` into the folder `_templates` at the notebook root. Never write or change anything in `_templates/` or `playbook/templates/` (the settings block it: Obsidian's Templater add-on can run code from templates). Only check that `_templates/daily.md` and `_templates/week.md` are there; if one is missing, add the line `templates missing` to `playbook/state/planner.md` and carry on. Then the Obsidian settings. Merge, never replace: the kit already put some files in `.obsidian/`, and Obsidian adds its own.
   - **Never write anything in `.obsidian/`** (the settings and a safety check block it: Obsidian runs add-on code and template code from there). The installer already wrote the settings this stage needs; only read them.
   - **One daily-note maker only.** The Periodic Notes add-on makes the day note and the week note, from `_templates/daily` and `_templates/week` (the week note is named `week-<yyyy>-W<nn>`, the same name `weekly-review` uses), in this language's `daily` folder. Obsidian's own built-in Daily notes feature must stay off, or two makers could each make a note for the same day.
   - Check, by reading only: `.obsidian/templates.json` has `"folder":"_templates"`; `.obsidian/daily-notes.json` has this language's `daily` folder and `"template":"_templates/daily"`; `.obsidian/core-plugins.json` has `templates` on and `daily-notes` off or missing; `.obsidian/community-plugins.json` lists `dataview`, `templater-obsidian` and `periodic-notes`; `.obsidian/plugins/periodic-notes/data.json` has this language's `daily` folder. For each one that does not match, add one line to `playbook/state/planner.md` (`templates.json mismatch`, `daily-notes mismatch`, `core-plugins mismatch`, `community-plugins mismatch` or `periodic-notes folder mismatch`) and carry on; never fix it yourself (Kas fixes it; the helpers still write notes in the right folder).
   - The templates keep their `{{date:YYYY-MM-DD}}` and `{{title}}` placeholders. Obsidian's Templates feature and Periodic Notes both fill those in. Templater is there for later, richer templates; never rewrite the kit's templates into Templater's own `<% %>` form.
   - **The week page.** Read `playbook/dashboards/<language>.md` and write it, unchanged except for the `{{date:YYYY-MM-DD}}` placeholder, as `my-week.md` (es-MX: `mi-semana.md`) in the `home` folder. If it is already there, leave it. Its lists are filled in by Dataview, the add-on switched on in stage 1; never write anything into its lists yourself.

6. **Personal rules file.** Read `playbook/templates/rules-CLAUDE.md` and overwrite `CLAUDE.md` at the notebook root with it, filled in:
   - `<name>` and `<language>` from `profile.json`.
   - "How to talk to me": 2-4 lines from area 1 (tone, length, what annoys them), written as instructions to you.
   - "Never": en-GB keeps the four English lines exactly. es-MX uses exactly the four Spanish lines from the comments in the template (the first starts `Nunca envíes correos`), in place of the English ones.
   - "Tools (for Claude)": keep these three lines in English exactly as they are, in both languages.
   - "My folders": copy the `## Folder names` table from the language profile.
   - "My helpers": write one line, `(added in stage 5)` (es-MX: `(se agregan en la etapa 5)`).
   - Remove every `<!-- ... -->` comment. Keep the "Setup" line in English exactly as it is.

7. **Show them.** Show a question box, with the real `home` folder name:
   en-GB: "Have a look at Obsidian, your notebook. On the left are your new folders. Click the <home> folder: inside is a note about you, and a page called My week that fills itself in. Can you see them?" Options: **Yes, I can see them (Recommended)** / **I can't see them** / **Explain more**.
   es-MX: "Échale un ojo a Obsidian, tu cuaderno. A la izquierda están tus carpetas nuevas. Dale clic a la carpeta <home>: adentro hay una nota sobre ti y una página que se llama Mi semana, que se llena sola. ¿Las ves?" Options: **Sí, ya las veo (Recomendado)** / **No las veo** / **Explícame más**.
   - "I can't see them": bring Obsidian to the front with `Start-Process "obsidian://open?path=<notebook path, URL-encoded>"`, explain where the left side panel is (en-GB "the list down the left-hand side of the Obsidian window"; es-MX "la lista del lado izquierdo de la ventana de Obsidian"), and ask again.
   - If they say the week page shows grey boxes with odd words instead of lists, the Dataview add-on is off: walk them through stage 1 step 4 a-d again, one box per click, then ask again.
   - Test mode: log `SKIPPED-TEST 4.7 show folders in Obsidian` in `playbook/state/test-log.md` and carry on.
   Then say one line on what they can do with it: en-GB "Click any note to read it. You can change anything; it's yours." es-MX "Dale clic a cualquier nota para leerla. Puedes cambiar lo que quieras; es tuyo."

8. **Setup extras.** If `playbook/setup/stage-4.md` exists, follow every step in it now. Add every folder it creates to `playbook/state/folders.md`, one per line, so the stage 6 backup includes them. If the file does not exist, skip this step.

9. **Finish.** When everything under "Done when" is true, create `playbook/state/stage-4.done` (one line: the date and time), set `current_stage: 5` and `updated: <now, ISO 8601>` in `playbook/progress.md`, and move on to stage 5 in the same sitting unless they typed pause.

## Done when
- Every folder in the language profile's `## Folder names` table exists with its `what-goes-here.md` (es-MX `que-va-aqui.md`) note, and `playbook/state/folders.md` lists them.
- `about-me.md` and `my-week.md` (es-MX `mi-semana.md`) are in the `home` folder, and at least 1 goal note is in the `goals` folder.
- `_templates` holds the note templates and `.obsidian/templates.json` points to it.
- The Obsidian settings were checked by reading only (step 5), and any mismatch is a line in `playbook/state/planner.md`.
- `CLAUDE.md` contains "Never send email" (en-GB) or "Nunca envíes correos" (es-MX).
- `playbook/state/stage-4.done` exists.
