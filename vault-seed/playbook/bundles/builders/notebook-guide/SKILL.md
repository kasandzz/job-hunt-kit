---
name: notebook-guide
description: Keep one note, How my notebook works, up to date: their folders in plain words, the helpers they have, and the exact words that start each one. Rewrites only that one note, when asked, and never deletes or changes any other note. Triggers: "how does my notebook work", "update my notebook guide", "cómo funciona mi cuaderno", "actualiza la guía de mi cuaderno", "kaip veikia mano sąsiuvinis", "atnaujink sąsiuvinio vadovą".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and the access profile `playbook/profiles/access-<access>.md`. Speak only in that language, use its folder table, and never show a word from its "Avoid" list. Question boxes never have more options than the access profile allows: when a box below lists more, keep the first ones and **tell me more** (es-MX **cuéntame más**). If `playbook/setup/shop-rules.md` or `playbook/setup/founder-rules.md` exists, read it too and follow it.

2. **The one note.** This helper writes one file and no other: `how-my-notebook-works.md` in the `home` folder (es-MX `como-funciona-mi-cuaderno.md`). Look for it with the Glob tool under both names. Then:
   - They said "update my notebook guide" (es-MX "actualiza la guía de mi cuaderno"), or another helper sent you here: do steps 3 to 6 without asking.
   - They said "how does my notebook work" (es-MX "cómo funciona mi cuaderno") and there is no guide yet: do steps 3 to 6.
   - They said it and the guide is there: do step 3 and compare. Nothing new: go straight to step 6. A helper or folder the guide does not have: one question box, en-GB "Your guide is missing <n> new things. Shall I bring it up to date?" es-MX "A tu guía le faltan <n> cosas nuevas. ¿La pongo al día?" Options: **Yes, update it (Recommended)** / **Not now** / **tell me more** (es-MX **Sí, actualízala (Recomendado)** / **Ahora no** / **cuéntame más**). Not now = step 6 with the guide as it is.

3. **Look, without changing anything.**
   - Folders: every row of the `## Folder names` table in the language profile, in table order. The plain line for each is the `summary:` of the `what-goes-here.md` note inside it (es-MX `que-va-aqui.md`). Then any other folder at the top of the notebook that holds notes (a setup's own folder, or one they made): one plain line from the setup rules file, or from the titles of up to 3 notes inside. Leave out `playbook`, `_templates` and every folder whose name starts with a dot.
   - Helpers: with the Glob tool, `.claude/skills/*/SKILL.md`. Read only the first 4 lines of each. From the `description:` line keep the phrases after `Triggers:`. If Glob shows nothing, use the lines under `## My helpers` in `CLAUDE.md` at the notebook root.
   - What each helper does: the half-line it already has under `## My helpers` in `CLAUDE.md`, with any "(needs Gmail linked; ask Kas)" note that line carries. No line there: write half a line a child would follow.
   - Helpers in `playbook/setup/asleep/` that are not in `.claude/skills/` are not switched on yet: count them, do not list them.

4. **Write the guide** in their language, short enough to read in two minutes:
   ```
   ---
   type: notebook-guide
   title: "<How my notebook works / Cómo funciona mi cuaderno>"
   created: <yyyy-mm-dd of the first time; keep it on every rewrite>
   updated: <yyyy-mm-dd>
   status: active
   tags: [notebook-guide]
   summary: "<one line: your folders, your helpers and the words that start each one>"
   ---
   # <title>
   <2 short lines: what the notebook is, and that they talk and you do the work>
   ## My folders / Mis carpetas
   - **<folder name from the language profile>**: <plain line>
   ## My helpers / Mis ayudantes
   <1 line: a helper is a short sentence they say, and you do a job for them>
   - Say **<phrase 1>** or **<phrase 2>**: <what it does>.
   ## Other things I can say / Otras cosas que puedo decir
   - <each line under "My helpers" in CLAUDE.md that is not a helper, for example the one about help for Kas>
   ## What my helper never does / Lo que mi ayudante nunca hace
   - <each line under "Never" in CLAUDE.md, in plain words>
   ## My own notes / Mis apuntes
   <theirs: see below>
   ```
   - Phrases: en-GB shows the English ones, es-MX the Spanish ones (es-MX "Di **<frase 1>** o **<frase 2>**: ..."). Copy every phrase word for word. Never reword or translate one: only the exact words are sure to start the helper. A helper with no phrase in their language: show the ones it has.
   - Sub-folders (a row whose folder has a `/`) go under their parent folder, set in a little.
   - More than 8 helpers: put them under plain headings by what they are for. en-GB: Every day / Learning / Email, diary and files / Work / Making things / My business / Ones we built together. es-MX: Para todos los días / Aprender / Correo, agenda y archivos / Trabajo / Armar cosas / Mi negocio / Los que armamos juntos. Leave out a heading with nothing under it.
   - Asleep helpers: if there are any and `switch-on` is one of their helpers, close "My helpers" with one line: en-GB "<n> more helpers are asleep. Say <the first phrase of `switch-on`> when you want one." es-MX "Hay <n> ayudantes más dormidos. Di <frase> cuando quieras uno."
   - "My own notes": anything they wrote under that heading in the old guide is theirs. Copy it across word for word, every time. The first time, write one line there: en-GB "Write anything you like here. I'll keep it." es-MX "Escribe aquí lo que quieras. Yo lo conservo."

5. **Save it** with the file-writing tool, over the old guide. This is the only note this helper may rewrite. If a note with that name is there but its top block does not say `type: notebook-guide`, it is theirs: leave it alone and save the guide with `-2` at the end of its name.

6. **Tell them** in 3-4 short lines: en-GB "Your notebook has <n> folders and <n> helpers. The guide is in <home folder name>, in the note How my notebook works. In Obsidian (the program where your notebook lives), it's in that folder on the left. Try saying: <one phrase that suits them>." es-MX "Tu cuaderno tiene <n> carpetas y <n> ayudantes. La guía está en <carpeta>, en la nota Cómo funciona mi cuaderno. En Obsidian (el programa donde vive tu cuaderno), está en esa carpeta, a la izquierda. Prueba decir: <frase>." If they asked about one folder or one helper, answer just that in one or two lines from the guide. If another helper sent you here, say only: en-GB "I've added it to your notebook guide." es-MX "Ya lo puse en la guía de tu cuaderno."

## Never
- Never write, change, move, rename or delete any note other than the one guide note. Everything else is read only here.
- Never delete the guide note either; rewrite it in place and keep "My own notes" word for word.
- Never change a helper, `CLAUDE.md`, a setting, or any file in `playbook/` or `.claude/`.
- Never reword or translate a starting phrase; copy it exactly as the helper has it.
- Never list a helper that is not in `.claude/skills/`, and never show a helper's folder name or file name.
- Never put anything from `interview.md`, health or worries details, or passwords, bank, card or ID numbers into the guide.
- Never use tech words from the language profile's "Avoid" list.
