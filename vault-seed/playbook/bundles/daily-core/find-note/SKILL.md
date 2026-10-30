---
name: find-note
description: Find a note they saved in their notebook. Looks at each note's one-line summary and title first, and reads the full text only if that finds nothing. Shows up to 5 matches with the folder and the date. Triggers: "find my note about", "where did I save", "busca mi nota", "dónde guardé".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.

2. **What to look for.** Pick 1-3 key words from what they said (for example "lemon cake", "Ruth", "passport"). Add the same idea in other words, and in the other language (English or Spanish) when that helps ("cake" / "pastel"). Only ask if you have nothing to search on: one question box, en-GB "What is the note about? A word or two is enough." es-MX "¿De qué es la nota? Con una o dos palabras basta." Options: 3 guesses from their recent notes, plus **tell me more** (es-MX **cuéntame más**).

3. **First look: titles and summaries.** Use the Grep tool, ignoring capitals, on lines that start with `title:` or `summary:` in `.md` files, across the notebook. Also use the Glob tool for file names that hold a key word (`**/*<word>*.md`).
   Skip these places and files every time:
   - `playbook/`, `.claude/`, `.obsidian/` and `_templates/`;
   - any note with `type: folder-guide` (the "what goes here" notes);
   - the week page (`type: dashboard`).
   If Grep finds nothing in a folder you know has notes, use the Glob tool with the file name instead (see `playbook/TROUBLESHOOTING.md`).
   Quicker way, only if `playbook/state/obsidian-tool.md` says `cli: on`: follow `playbook/obsidian-tool.md` and ask Obsidian itself with `obsidian search query="<words>" limit=20`, with the same places skipped. If it fails in any way, carry on with Grep and Glob as above and say nothing.

4. **Second look, only if the first found nothing.** Grep the full text of the notes for the key words, with the same places skipped. Never read more than the 20 best files.

5. **Show up to 5**, best match first, one short line each, in plain words:
   - en-GB: "<title> - in <folder name from the language profile>, saved <date in words, for example 3 October 2026>. <its summary line>"
   - es-MX: "<title> - en <folder name>, guardada el <date in words, for example 3 de octubre de 2026>. <its summary line>"
   Take the date from `created:` (or from the file name if there is none). Then a question box: en-GB "Shall I show you one?" es-MX "¿Te enseño una?" Options: **Show me the first one (Recommended)** / **Show me another** / **That's all, thanks** / **tell me more** (es-MX **Enséñame la primera (Recomendado)** / **Enséñame otra** / **Ya está, gracias** / **cuéntame más**).
   - Show me = read that note and give a 2-3 line summary in their words, then say where it lives in Obsidian: en-GB "In Obsidian, it's in the <folder> folder on the left." es-MX "En Obsidian está en la carpeta <folder>, a la izquierda."
   - Show me another = ask which one, by number, in the same kind of box.

6. **Nothing found.** Say it plainly: en-GB "I couldn't find a note about that in your notebook." es-MX "No encontré una nota de eso en tu cuaderno." Then a question box with: **Try other words (Recommended)** / **Leave it** / **tell me more** (es-MX **Probar otras palabras (Recomendado)** / **Déjalo** / **cuéntame más**). Only if `drive: connected` in `playbook/state/connectors.md`, add **Look in my Google Drive** (es-MX **Buscar en mi Google Drive**); that option follows the `drive-finder` helper.

## Never
- Never change, move, rename or delete a note. This helper only reads.
- Never show passwords, bank or card numbers, or ID numbers, even if a note has them; say `(private)` instead.
- Never read out health or worries details from `interview.md` or any file in `playbook/`.
- Never show more than 5 matches at once.
- Never use tech words from the language profile's "Avoid" list.
