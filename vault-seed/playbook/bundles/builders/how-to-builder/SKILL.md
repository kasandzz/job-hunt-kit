---
name: how-to-builder
description: Turn the way they do a job into a short step-by-step note they can follow next time or hand to someone else. Asks a few short questions, shows the steps for a yes, then saves one note in the how-to folder. Triggers: "write down how I do this", "make a how-to", "anota cómo hago esto", "haz un paso a paso".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and the access profile `playbook/profiles/access-<access>.md`. Speak only in that language, use its folder table, and never show a word from its "Avoid" list. Question boxes never have more options than the access profile allows: when a box below lists more, keep the first ones and **tell me more** (es-MX **cuéntame más**). If `playbook/setup/shop-rules.md` or `playbook/setup/founder-rules.md` exists, read it too and follow it.

2. **Which job?** Take it from what they said (for example "how I close up at night"). Say once what you are making: en-GB "A how-to is a short list of steps, in order. Next time, you or anyone else just follows the list." es-MX "Un paso a paso es una lista corta de pasos, en orden. La próxima vez, tú o quien sea solo sigue la lista."
   - No job named: one question box, en-GB "Which job shall we write down?" es-MX "¿Qué tarea anotamos?" Options: 2-3 guesses from things they do again and again (`about-me.md` in the `home` folder, their last few daily notes), best guess first, plus **tell me more**.
   - The guide this kit comes from calls this an SOP. Never say that word first. If they say it (or "procedimiento"), answer once: en-GB "Yes. An SOP is just a how-to: the steps for a job, written down in order." es-MX "Sí. Un SOP es un paso a paso: los pasos de una tarea, escritos en orden." After that say "how-to" / "paso a paso".
   - With the Glob tool, look in the `howto` folder for a note about the same job. If there is one, go to step 8 and skip steps 3 to 7.

3. **Get the steps.** Use what they already told you in this chat. If you have no steps yet, one question box: en-GB "Tell me what you do, from the start to the end. Say it any way you like. I'll put it in order." es-MX "Cuéntame qué haces, desde el principio hasta el final. Dilo como te salga. Yo lo pongo en orden." Options: **I'll tell you now (Recommended)** / **You have a first go and I'll fix it** / **tell me more** (es-MX **Te cuento ahorita (Recomendado)** / **Haz tú un primer intento y yo lo corrijo** / **cuéntame más**). A first go = write the steps you think are likely and say plainly that they are your guess; nothing is saved until their yes in step 6.

4. **Fill the gaps.** At most 3 more question boxes, one at a time, and only for what you still do not know. Each has 2-3 guesses built from their own words, best guess first, plus **tell me more**:
   - What to have ready: en-GB "What do you need to have with you before you start?" es-MX "¿Qué necesitas tener a la mano antes de empezar?"
   - How they know it worked: en-GB "How do you know it went well?" es-MX "¿Cómo sabes que quedó bien?"
   - The tricky part: en-GB "Is there a part that often goes wrong?" es-MX "¿Hay una parte que seguido sale mal?" Add the option **No, nothing** (es-MX **No, nada**).

5. **Write it short.**
   - 3 to 9 steps. More than 9: split it into two parts, each with a short name.
   - One step is one line and one thing to do. It starts with a doing word ("Open", "Count", "Call"; es-MX "Abre", "Cuenta", "Llama").
   - Use their own words for things and places. Explain a hard word in brackets the first time it comes up.
   - Where a step needs a password, a PIN or a card number, write `(your password - not written here)` (es-MX `(tu contraseña - no se escribe aquí)`).
   - Write only what they said. For any step about medicine, money, the law, tax, gas or electrics, add one line: en-GB "Check this with the right person, for example your doctor or your accountant." es-MX "Confirma esto con la persona indicada, por ejemplo tu médico o tu contador."

6. **Show it for a yes, in its own box.** The box text holds the whole how-to, exactly as it will be saved. en-GB "Here is your how-to. Is it right?" es-MX "Este es tu paso a paso. ¿Así está bien?" Options: **Yes, save it (Recommended)** / **Change something** / **Don't save it** / **tell me more** (es-MX **Sí, guárdalo (Recomendado)** / **Cambiar algo** / **No lo guardes** / **cuéntame más**). Change something = ask what, rewrite, show the whole thing again. Don't save it = stop; nothing is saved.

7. **Save it** only after "Yes, save it", with the file-writing tool, in the `howto` folder (if the folder table has no `howto` row, use `home`). File name: `<two-to-five-words>.md`, lowercase, words joined by hyphens, no accents, no date (for example `close-up-at-night.md`). If that name is taken, add `-2`; never overwrite. Headings in their language:
   ```
   ---
   type: how-to
   title: "<How I ... / Cómo ...>"
   created: <yyyy-mm-dd>
   status: active
   tags: [how-to]
   summary: "<one line: which job this is and when to use it>"
   ---
   # <title>
   ## What you need / Qué necesitas
   - <thing>
   ## Steps / Pasos
   1. <step>
   ## You know it worked when / Sabes que quedó bien cuando
   <one line>
   ## Watch out for / Ojo con
   - <the tricky part; leave this heading out if there is none>
   ## Changes / Cambios
   - <yyyy-mm-dd>: <written / escrito>
   ```
   Then tell them in two lines: en-GB "Saved in <howto folder name>: <title>. To give it to someone, open it in Obsidian (the program where your notebook lives) and print it, or copy the words into a message yourself." es-MX "Guardado en <carpeta>: <título>. Para dárselo a alguien, ábrelo en Obsidian (el programa donde vive tu cuaderno) e imprímelo, o copia tú el texto en un mensaje."

8. **A how-to they already have.** Read it, then one question box: en-GB "You already have a how-to for this. What shall we do?" es-MX "Ya tienes un paso a paso de esto. ¿Qué hacemos?" Options: **Read it to me (Recommended)** / **Change a step** / **Write a new one** / **tell me more** (es-MX **Léemelo (Recomendado)** / **Cambiar un paso** / **Escribir uno nuevo** / **cuéntame más**).
   - Read it to me = show the steps, one short line each.
   - Change a step = ask what changed, show the whole new text as in step 6, and after their yes change only those lines in that note and add `- <yyyy-mm-dd>: <what changed>` under "Changes".
   - Write a new one = steps 3 to 7; the new note gets `-2` in its name.
   - A how-to they no longer use: set `status: old`. Never remove it.

## Never
- Never save a how-to before they say yes to the full text.
- Never add a step, a number, a name or a time they did not give you. A first go is always called a guess.
- Never add or change a fact about medicine, money, the law, tax, gas or electrics yourself.
- Never send, share, post or print a how-to for them; they hand it over themselves.
- Never write passwords, PINs, bank or card numbers, or ID numbers into a how-to.
- Never delete or overwrite a how-to note; one they no longer use changes `status:` only.
- Never say "SOP" unless they said it first, and then explain it in plain words.
- Never use tech words from the language profile's "Avoid" list.
