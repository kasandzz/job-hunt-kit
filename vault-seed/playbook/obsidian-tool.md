# The quick way to look through the notebook (for Claude - the user never reads this)

Obsidian, the program where their notebook lives, has a built-in command tool. With it you can ask Obsidian itself: search the notes, list every label, find notes nothing points to, and read a note's top block without opening the note. It works only when the person has switched it on once by hand, and only while Obsidian is open.

Never say "command line", "CLI" or "terminal" to the user. If you must name it, call it "the quick way to look through your notebook" (es-MX "la manera rápida de buscar en tu cuaderno").

## Is it on?
Read `playbook/state/obsidian-tool.md`.
- `cli: on`: use it. Before the first use in a sitting, run exactly `obsidian version`. A version number = fine. Anything else (it says "Command line interface is not enabled", it cannot be found, any error) = overwrite the state file with `cli: off` and use the plain way for the rest of the sitting. Never show the error.
- `cli: pending`: they did the clicks, but this computer had not noticed yet. Run exactly `obsidian version` once. A version number = write `cli: on`. Anything else = leave it `pending` and use the plain way.
- `cli: off`, `cli: skipped`, `cli: skipped-test` or no file: use the plain way (the Grep and Glob tools, as each helper says) and say nothing about it.

## Commands you may run (they only read)
Run them from the notebook folder, so the tool picks this notebook.
- `obsidian search query="<words>" limit=20` - notes that hold the words. Add `path="<folder>"` to look in one folder.
- `obsidian tags counts sort=count` - every label and how often it is used.
- `obsidian tag name="<label>" verbose` - the notes with one label.
- `obsidian orphans` - notes that no other note points to.
- `obsidian unresolved` - links that point to a note that is not there.
- `obsidian backlinks path="<note path>"` - notes that point to one note.
- `obsidian properties path="<note path>"` and `obsidian property:read name="<key>" path="<note path>"` - a note's top block, without opening the note.
- `obsidian files folder="<folder>"` and `obsidian folders` - what is where.
Leave out anything it finds in `playbook/`, `.claude/`, `.obsidian/`, `.planning/` and `_templates/`, the same as the plain way.

## Moving a note
Only where a helper already allows a move (the inbox tidy in `weekly-review`), and only after they said yes: `obsidian move path="<old path>" to="<new folder>"`, one note per command. It keeps the links between notes working. A permission box may pop up; the helper already tells them. If it fails, use the helper's usual way.

## Never
- Never run `obsidian delete`, `obsidian eval`, `obsidian command`, `obsidian property:remove`, any `plugin:`, `theme:`, `snippet:` or `dev:` command, `obsidian devtools`, `obsidian restart` or `obsidian reload`. The dangerous ones are blocked on purpose.
- Never point it at another notebook (`vault=`), and never run the program by its full path. Only the plain `obsidian <command>` form.
- Never mention this tool to the user unless they must click something for it.

## Switching it on
Do this when stage 1 says so, or later when they say **switch on the quick search** / **prende la búsqueda rápida**. Obsidian must be open. Test mode: do not walk through anything; write `cli: skipped-test` to `playbook/state/obsidian-tool.md`, log `SKIPPED-TEST 1.5 Obsidian quick search switch` in `playbook/state/test-log.md` and carry on.
Walk them through it one click at a time. Each click is one question box whose text says exactly what to click. Options, within the access profile's limit: en-GB **Done (Recommended)** / **Stuck** / **Explain more**; es-MX **Listo (Recomendado)** / **Me atoré** / **Explícame más**.
a. en-GB: "One more switch in Obsidian, your notebook program. It lets me find your notes faster. Look at the bottom-left corner of Obsidian and click the little gear wheel. That opens Settings." es-MX: "Un interruptor más en Obsidian, el programa de tu cuaderno. Con él encuentro tus notas más rápido. Mira la esquina de abajo a la izquierda de Obsidian y dale clic al engrane chiquito. Así se abre la Configuración."
b. en-GB: "On the left of that window, click 'General'. Then scroll down to the part called 'Advanced'." es-MX: "A la izquierda de esa ventana, dale clic en 'General'. Luego baja hasta la parte que dice 'Advanced'."
c. en-GB: "Find the line that says 'Command line interface'. Click its switch so it turns on (coloured, not grey). That name just means: other programs on this computer may ask Obsidian questions." es-MX: "Busca el renglón que dice 'Command line interface'. Dale clic a su interruptor para prenderlo (de color, no gris). Ese nombre solo quiere decir: otros programas de esta computadora le pueden hacer preguntas a Obsidian."
d. en-GB: "A new button appears just below, called 'Register'. Click it once. Then close Settings with the X in the top-right corner." es-MX: "Abajo aparece un botón nuevo que dice 'Register'. Dale un clic. Luego cierra la Configuración con la X de la esquina de arriba a la derecha."
On **Stuck**: ask what they see (a box with 2-3 likely answers, for example en-GB "I can't find that line" / "there is no Register button" / "Leave it for today"; es-MX "No encuentro ese renglón" / "No hay botón Register" / "Déjalo por hoy"). Always offer "Leave it for today". If they are stuck twice or choose to leave it: write `cli: skipped`, and say kindly: en-GB "No problem, we'll leave that one. Kas can switch it on for you another day. Everything still works without it." es-MX "No pasa nada, lo dejamos. Kas te lo puede prender otro día. Todo funciona igual sin eso."
After d, run exactly `obsidian version`. A version number: write `cli: on`. Anything else: write `cli: pending` (this computer notices the new tool the next time Claude is opened) and carry on without a word.
The state file is one line, `cli: on | pending | off | skipped | skipped-test`, plus `checked: <date and time>`.
