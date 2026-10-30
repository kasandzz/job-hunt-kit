# Troubleshooting (for Claude - the user never reads this)

Read this when a step has failed twice. Each entry is **symptom → fix**. Try the fix once. If it still fails, tell the user kindly that this one needs Kas and make the help file (last section). Never delete anything, never ask the user to delete anything, and never use a word from the language profile's "Avoid" list when you explain.

## Fixes

- **Gmail, Drive and Calendar all vanish at once** (the tools are missing or every call fails) → ask the user to close every Claude window and open just one again, then type **carry on** / **seguimos**. Do not reconnect anything first; this nearly always brings them back.

- **Drive says "not found" for a file the user knows exists** → only the Google account connected in stage 2 is searched. Ask which account the file lives in. If it is a different account, the file cannot be found from here; suggest they share it with their connected account, or open it themselves.

- **The video helper fails with a 403 or "forbidden" error** → captions only, never `--download`. Run the helper again exactly as `powershell -NoProfile -ExecutionPolicy Bypass -File playbook/tools/get-subs.ps1 -Url "<url>"`. If it still fails, offer the title-only summary from the video helper.

- **Files with accents in their names (for example `tía-lupe.md`) don't get backed up, or show up as `\303\255`** → check `git config core.quotepath`; it must say `false`. If not, run `git config core.quotepath false`. New note names should not have accents anyway (`tia-lupe.md`): save a copy without the accent, and leave the old file where it is (it stays backed up).

- **Running `bash` opens Linux (WSL) or asks to install a Linux distribution** → never use plain `bash`. Use `C:\Program Files\Git\bin\bash.exe`, or run the command in PowerShell instead.

- **`python3` hangs, or opens the Microsoft Store** → that is a Windows Store placeholder, not real Python. Nothing in this kit uses Python. Ignore it and carry on.

- **Git warns about line endings (LF / CRLF), or every file shows as changed** → never "repair" or rewrite files to fix line endings. `.gitattributes` handles it. Carry on.

- **The Grep search tool can't find a file you know is there** → Grep skips folders the backup ignores. Use the Glob tool with the file name instead.

- **A hook error mentions a strange character (for example `â€"` or `Ã`)** → one of the `.ps1` files is not plain ASCII (an accent, a curly quote or a long dash crept in). Do not edit it yourself; scripts are write-protected on purpose. Make the help file for Kas.

- **The user moved, renamed or deleted a note in Obsidian, and the old copy is still in the online backup** → moved or deleted notes are not backed up automatically. The automatic backup only saves notes Claude writes. Notes in the inbox get moved for them in the weekly review ("weekly review" / "revisión semanal", the "Tidy the inbox" step), which saves each note in its new place. For any other note, move it the same way: `Move-Item` (never overwrite; add `-2` to the name if one is already there), then edit the moved note once (add `sorted: <yyyy-mm-dd>` to its front matter) so the backup saves it. Never delete. Tell the user gently: en-GB "If you want to move a note, just ask me. I'll move it so it stays in your safe copy." es-MX "Si quieres mover una nota, nada más pídemelo. Yo la muevo para que siga en tu copia segura."

- **The week page (My week / Mi semana) shows grey boxes of code instead of lists** → the Dataview add-on is switched off. Walk them through stage 1 step 4, boxes a to d, one click per box (the trust box, the gear wheel, "Community plugins", the Dataview switch). If Dataview is not in the list at all, check that `.obsidian/community-plugins.json` lists `"dataview"` and that `.obsidian/plugins/dataview/main.js` exists; if either is missing, never rebuild it from memory: make the help file. Tell them: en-GB "One small switch in Obsidian is off. Let's turn it on together." es-MX "Un interruptor chiquito de Obsidian está apagado. Vamos a prenderlo juntos."

- **A notebook folder is missing (for example someone renamed it in Obsidian)** → never recreate folders with a shell command. Write its "what goes here" note again with the file-writing tool (`<folder>/what-goes-here.md`, es-MX `que-va-aqui.md`, the sentence from stage 4 step 1), which brings the folder back. If a folder with a similar name now holds their notes, leave it where it is and ask in a question box which name to keep.

- **Online backup failed (`playbook/state/last-push-failed` exists)** → everything is still safe on this computer. Run the help file (last section) and ask the user to send it to Kas. Do not try to fix the online copy yourself, and never force anything.

- **The online copy is not private, or the privacy check cannot run** (`gh repo view --json visibility -q .visibility` prints anything other than `PRIVATE`, or without `gh` the anonymous check does not return `404`) → stop uploading now: if `git remote` lists `origin`, run `git remote rename origin backup-unchecked`. The automatic backup only uploads to `origin`, so this stops it; it only renames the connection and changes no files. Then make the help file and tell the user Kas needs to look at one setting. Never change visibility to public.

## Sharing with Kas

Kas should fill `helper_github` in `playbook/state/helper.json` when he builds the kit, so the user never has to type it.
Only when the user says "share my notes with Kas" ("comparte mis notas con Kas"):
1. Show a question box: en-GB "This lets Kas read all your notes in your online copy. He can look, but he can't change them. You can stop it any time by saying: stop sharing with Kas. Share them with Kas?" es-MX "Así Kas puede leer todas tus notas en tu copia en línea. Las puede ver, pero no cambiar. Lo puedes parar cuando quieras diciendo: deja de compartir con Kas. ¿Se las compartimos a Kas?" Options: **No, keep them private (Recommended)** / **Yes, share with Kas** / **tell me more** (es-MX **No, que sigan privadas (Recomendado)** / **Sí, compartir con Kas** / **cuéntame más**). Anything except an explicit "Yes, share with Kas" ("Sí, compartir con Kas") means stop.
2. Read `helper_github` in `playbook/state/helper.json`. If it is empty, tell them: en-GB "Please ask Kas for his GitHub name (the name he uses on that website) and type it here." es-MX "Pídele a Kas su nombre de GitHub (el nombre que usa en esa página) y escríbelo aquí." It must match `^[A-Za-z0-9-]{1,39}$` (letters, numbers and dashes, at most 39); if not, ask again and never put it into a command. When it matches, save it as `helper_github` in `helper.json`.
3. Check who that is. `helper_github` must match `^[A-Za-z0-9-]{1,39}$` (also when Kas filled it in); if not, stop and say this one needs Kas. Run `gh api users/<helper_github> --jq "[.login, .name] | @tsv"`. If it fails, the username is wrong: say so and stop. Otherwise show a second box: en-GB "Share your notes with <login> (<name>)? Please check this is really Kas." es-MX "¿Compartir tus notas con <login> (<name>)? Fíjate que de verdad sea Kas." Options: **No (Recommended)** / **Yes, that's Kas** / **tell me more** (es-MX **No (Recomendado)** / **Sí, es Kas** / **cuéntame más**). Only an explicit "Yes, that's Kas" ("Sí, es Kas") carries on.
4. Find their copy's full name with `gh repo view --json nameWithOwner -q .nameWithOwner` (it looks like `<owner>/<repo>`).
5. Run `gh api -X PUT repos/<owner>/<repo>/collaborators/<helper_github> -f permission=pull`. Tell them: en-GB "Done. Kas gets an email, and once he says yes he can read your notes." es-MX "Listo. A Kas le llega un correo, y cuando acepte ya puede leer tus notas." Note the date in `playbook/state/helper.json` as `shared_on`.

## Stop sharing with Kas

When the user says "stop sharing with Kas" ("deja de compartir con Kas"): find the copy's full name as in step 4 above, then run `gh api -X DELETE repos/<owner>/<repo>/collaborators/<helper_github>`. This only removes Kas's access; no notes change. Tell them: en-GB "Done. Kas can't see your notes online any more." es-MX "Listo. Kas ya no puede ver tus notas en línea." Set `shared_on` to empty in `helper.json`.

## Making the help file for Kas

When the user says "help me send this to Kas" ("manda esto a Kas"), or a fix above says so:
1. Run exactly: `powershell -NoProfile -ExecutionPolicy Bypass -File playbook/help-bundle.ps1`
2. It prints the path of a zip on their Desktop, named `help-for-kas-<date>-<time>.zip`.
3. Tell them: en-GB "I've put a small file called <file name> on your Desktop (the main screen of your computer). Please send it to Kas on WhatsApp. It has none of your notes in it, only how the setup is going." es-MX "Dejé un archivo chiquito que se llama <file name> en tu Escritorio (la pantalla principal de tu computadora). Mándaselo a Kas por WhatsApp. No lleva ninguna de tus notas, solo cómo va la instalación."
It contains only the setup log, progress, setup state files and settings. It never contains notes, interview answers, seeds, questions, the profile (email) or owner data.
