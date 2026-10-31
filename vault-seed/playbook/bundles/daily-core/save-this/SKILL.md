---
name: save-this
description: Save anything for later (an idea, link, recipe, person or task) into the right folder with a one-line summary. Triggers: "save this", "remember this", "guarda esto", "acuérdate de esto", "išsaugok tai", "įsimink tai".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.

2. **What is it?** Work out the type from what they gave you. Only ask if it is truly unclear, in one question box (en-GB "What is this, so I can put it in the right place?" es-MX "¿Qué es esto, para guardarlo en el lugar correcto?"; Idea / Link / Recipe / Person / Task, es-MX Idea / Enlace / Receta / Persona / Pendiente, best guess first, plus **tell me more** / **cuéntame más**).
   - A YouTube or Vimeo link: offer to summarise it instead (the `video-summary` helper). If they just want it kept, save it as a link.
   - If they shared a password, bank or card number or ID number, do not save that part; write `(private, not saved)` and tell them kindly why.

3. **Where it goes**, by folder key from the language profile:
   - idea -> `inbox`
   - link -> `learning` (a book -> `books`, a video -> `videos`)
   - recipe -> `home`
   - person -> `people`, using `playbook/templates/person.md`. If a note for that person already exists, add a line under "Things to remember" instead of making a new one.
   - task -> under "Notes" in today's note in the `daily` folder, as `- [ ] <task>`. If today's note does not exist yet, use `inbox`.
   - unsure -> `inbox`.

4. **Write the note.** Tasks do not get a note of their own: they go into today's daily note as in step 3. A person note is named after the person, `<first-name>-<last-name>.md` (no date). Everything else: `<yyyy-mm-dd>-<two-to-five-words>.md`. All file names lowercase, words joined by hyphens, no accents. Person notes use the person template; every other note starts with:
   ```
   ---
   type: <idea|link|recipe|person|task>
   title: "<short title in their language>"
   created: <yyyy-mm-dd>
   status: open
   tags: [<type>]
   summary: "<one line>"
   ---
   ```
   Then what they gave you, word for word, plus the link if there was one. If a note with the same name exists, add `-2` to the new name; never overwrite.

5. **Summary.** The `summary:` is one plain line in their language saying what it is and why they might want it later.

6. **Confirm in one line**, naming the folder as the language profile names it. Example (en-GB): "Saved in 00-Inbox: the lemon cake recipe from Jane." Example (es-MX): "Guardado en 00-Entrada: la receta de pastel de limón de Jane."

## Never
- Never overwrite or delete an existing note.
- Never ask more than one question; when in doubt, use `inbox`.
- Never change what they said; the summary is the only thing you write in your own words.
- Never save passwords, bank or card numbers, or ID numbers.
- Never use tech words from the language profile's "Avoid" list.
