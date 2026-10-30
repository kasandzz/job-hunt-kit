# Stage 5: Your helpers

## Goal
Install the ready-made helpers for this person, write the sentences that start each one into their personal rules file, and show two of them working on something from their own life. The user should leave this stage thinking "oh, that's useful".

## Steps
Before you start: read `playbook/state/profile.json`, `playbook/profiles/mode-<mode>.md`, the language profile and `playbook/state/connectors.md`. Tell them in two short lines: en-GB "Now I'll set up your helpers. A helper is a short sentence you say to me, like good morning, and I do a job for you." es-MX "Ahora preparo tus ayudantes. Un ayudante es una frase corta que me dices, como buenos días, y yo hago una tarea por ti."
Rules for this stage:
- Write every file with the file-writing tool (never a shell copy), so the backup notices it.
- Never change a helper's steps while copying it. Copy it exactly.
- When you tell the user about helpers, say "helper" ("ayudante"), never the word on the "Avoid" list.

1. **Which bundles.** Read the line under `## Bundles` in the mode profile. The bundle names are the comma-separated words before the bracket (for `mode-personal`: `daily-core`, `learning`, `life-admin`, `job-hunting`, `builders`). Each name is a folder in `playbook/bundles/`. The `builders` bundle holds the five making helpers: `big-plan` (plans one big thing step by step), `project-builder`, `how-to-builder`, `notebook-guide` and `hiring-helper`.

2. **Install.** The installer already placed the helpers in `.claude/skills/` (writing there from here needs a permission click every time). For each bundle, in order, and for each helper folder inside it (`playbook/bundles/<bundle>/<helper>/SKILL.md`):
   - If `.claude/skills/<helper>/SKILL.md` already exists with the same text (placed by the installer, or a resumed sitting), skip it. This is the normal case: do not rewrite it.
   - Only if it is missing: say once "A box may pop up asking if I can do this. Please click Allow." (es-MX: "Puede salir un aviso pidiendo permiso. Dale clic en Permitir."), read the bundle file, then write it unchanged to `.claude/skills/<helper>/SKILL.md`. If the write is refused, follow the "fails twice" rule in `PLAYBOOK.md` for that helper and carry on with the rest.
   - After each bundle, set `updated: <now, ISO 8601>` in `playbook/progress.md`.
   Then check with Glob that `.claude/skills/*/SKILL.md` has one file per helper folder you found. If one is missing, write it again.

3. **"My helpers" in CLAUDE.md.** Open `CLAUDE.md` at the notebook root. Under `## My helpers`, replace the placeholder line (`(added in stage 5)` or `(se agregan en la etapa 5)`) with one line per installed helper, in their language, in this form:
   `- "<phrase 1>", "<phrase 2>": <what it does, half a line>.`
   - Take the phrases from the `Triggers:` part of that helper's `description:` line. en-GB uses the English phrases; es-MX uses the Spanish ones (the ones with Spanish words, for example "buenos días").
   - If the helper needs a connection that is not `connected` in `connectors.md` (email helpers need Gmail, the calendar helper needs Calendar, the file finder needs Drive), add "(needs Gmail linked; ask Kas)" in their language (es-MX "(necesita Gmail conectado; pregúntale a Kas)").
   - Write the "what it does" half-line in plain words a child would follow, for example en-GB "finds a note you saved and tells you where it is", es-MX "busca una nota que guardaste y te dice dónde está".
   Then add these three lines at the end of `## My helpers`, exactly as below in their language:
   - en-GB: `- "help me send this to Kas": follow "Making the help file for Kas" in playbook/TROUBLESHOOTING.md and tell me the file name. It is on my Desktop; I send it to Kas on WhatsApp. It never contains my notes.`
     es-MX: `- "manda esto a Kas": sigue "Making the help file for Kas" en playbook/TROUBLESHOOTING.md y dime el nombre del archivo. Queda en mi Escritorio; se lo mando a Kas por WhatsApp. Nunca lleva mis notas.`
   - en-GB: `- "share my notes with Kas": see "Sharing with Kas" in playbook/TROUBLESHOOTING.md. Only after I say yes in a question box. "stop sharing with Kas" undoes it.`
     es-MX: `- "comparte mis notas con Kas": ver "Sharing with Kas" en playbook/TROUBLESHOOTING.md. Solo después de que diga que sí en una pregunta. "deja de compartir con Kas" lo deshace.`
   - en-GB: `- "build idea number <n>": follow playbook/new-helper.md to turn idea <n> from my ideas list into a new helper with me (stage 7 makes the list).`
     es-MX: `- "construye la idea número <n>": sigue playbook/new-helper.md para convertir la idea <n> de mi lista de ideas en un ayudante nuevo conmigo (la etapa 7 hace la lista).`
   Keep everything else in `CLAUDE.md` exactly as it is.

4. **Two live demos.** Read `playbook/state/interview.md` and pick the 2 demos that fit this person best, using only helpers whose connection is `connected`:
   - A video or channel they named in area 8: "summarise this video" with that video's link (if they named a channel but no video, use WebSearch to find one recent video from it and confirm in a question box first).
   - "what's in my email" (needs Gmail), or "what's on this week" (needs Calendar), which also flags birthdays from their people notes.
   - "my goals", using the goal notes from stage 4.
   - "save this" with something they mentioned wanting to keep (a recipe, a link, an idea).
   - "find my note about" with something already in their notebook from stage 4 (a person or a goal).
   Ask first in a question box: en-GB "Shall I show you two helpers working on your own things? First: <demo 1 in a few words>." es-MX "¿Te enseño dos ayudantes trabajando con tus propias cosas? Primero: <demo 1 en pocas palabras>." Options: **Yes, show me (Recommended)** / **Pick a different one** / **Skip the demos** / **tell me more** (es-MX **Sí, enséñame (Recomendado)** / **Escoger otro** / **Saltar los ejemplos** / **cuéntame más**). Run each demo by following that helper's steps from `.claude/skills/<helper>/SKILL.md`, start to finish. After each one, say the exact sentence they can use next time: en-GB "Next time, just say: <phrase>." es-MX "La próxima vez, solo di: <phrase>."
   - Remember: drafts only, never send. Never delete anything.
   - Test mode: do not ask; run 2 demos that need no connection ("my goals" and "save this" with a line from `seeds.md`) and log `SKIPPED-TEST 5.4 demo choice box` in `playbook/state/test-log.md`.

5. **Setup extras.** If `playbook/setup/stage-5.md` exists, follow every step in it now. If it does not exist, skip this step.

6. **Finish.** When everything under "Done when" is true, create `playbook/state/stage-5.done` (one line: the date and time), set `current_stage: 6` and `updated: <now, ISO 8601>` in `playbook/progress.md`, and move on to stage 6 in the same sitting unless they typed pause.

## Done when
- `.claude/skills/<helper>/SKILL.md` exists for every helper folder in every bundle the mode profile lists.
- `CLAUDE.md` has one line per helper under `## My helpers`, plus the "help me send this to Kas" (or "manda esto a Kas") line, and the placeholder line is gone.
- 2 demos were run, or the user chose to skip them.
- `playbook/state/stage-5.done` exists.
