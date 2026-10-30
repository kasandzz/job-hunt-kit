---
name: drive-finder
description: Find a file in Google Drive by searching with a few different phrasings and give the top 5 with links. Triggers: "find the file", "find my document", "busca el archivo", "encuentra mi documento".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language. Never show a word from its "Avoid" list.

2. **Connected?** Read `playbook/state/connectors.md`. If `drive:` is not `connected`, say kindly: en-GB "Your Google Drive (where Google keeps your saved files) isn't linked to me yet. Kas can help you link it." es-MX "Tu Google Drive (donde Google guarda tus archivos) todavía no está conectado conmigo. Kas te puede ayudar a conectarlo." Then stop.

3. **Understand what they want.** From their words, pick out the key words, roughly when, and what kind of file (letter, photo, spreadsheet, form). Only ask if you have nothing to search on; one question box with 3 guesses plus **tell me more**.

4. **Search with 2-3 phrasings** using `search_files`: their exact words; the same idea in other words (for example "CV", "curriculum", "resume"); and in the other language (English or Spanish) when that helps. Put all results together and drop duplicates.

5. **Show the top 5**, best match first, one line each: the file name as a link, what kind of file it is in plain words, and when it was last changed ("changed 3 weeks ago" / "modificado hace 3 semanas").
   If they want to know what is inside one, use `read_file_content` and give a 2-3 line summary.

6. **Nothing found.** Say plainly that nothing came up, and that only this Google account's Drive is searched, not the computer, email attachments or other accounts. Offer one more try with different words in a question box: en-GB "Shall I try again with other words?" es-MX "¿Busco otra vez con otras palabras?" Options: **Try other words (Recommended)** / **Leave it** / **tell me more** (es-MX **Probar otras palabras (Recomendado)** / **Déjalo** / **cuéntame más**).

## Never
- Never share, move, rename, copy or delete a file, and never change who can see it.
- Never write a file's contents into a note unless they ask.
- Never read out passwords, bank or card numbers, or ID numbers found inside a file.
- Never use tech words from the language profile's "Avoid" list.
