---
name: new-helper
description: Turn one card from their ideas list into a new helper, together, step by step. Checks it is safe to build, agrees the words that start it, writes it, tries it once and ticks the card. Triggers: "build idea number", "construye la idea número".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and `playbook/state/connectors.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list (say "helper" / "ayudante").

2. **Find the card.** Open `ideas.md` in the `home` folder and find the card whose heading starts `### <n>.` (the number they said). If there is no `ideas.md`, or no card with that number, say kindly en-GB "I can't find idea number <n> in your ideas list. Shall I show you the list?" es-MX "No encuentro la idea número <n> en tu lista. ¿Te enseño la lista?" and show the card names in a question box (up to 4, plus **tell me more** / **cuéntame más**). If the card already has a `Built` / `Hecho` line, tell them which sentence starts it and stop.

3. **Can it be built safely?** A helper may only read, write notes in their notebook, write email drafts, and look things up on the web. Check the card against this list. It cannot be built (as asked) if it needs any of these:
   - sending, posting, replying or forwarding anything (email, messages, social media);
   - buying or paying for anything, or anything with bank or card details;
   - signing in to a website, or keeping a password;
   - deleting anything, anywhere;
   - installing a program, changing computer or app settings, or running on a timer by itself;
   - a connection that is not `connected` in `connectors.md` (Gmail for email, Calendar for the diary, Drive for files).
   If one applies, offer the nearest safe version in plain words, for example en-GB "I can't send the birthday message for you, but I can write it and remind you the week before. Shall we build that?" es-MX "No puedo mandar el mensaje de cumpleaños por ti, pero sí lo puedo escribir y recordártelo una semana antes. ¿Armamos eso?" If no safe version makes sense, say kindly it needs Kas, and stop. A missing connection: say Kas can link it, and stop.

4. **Agree what it does.** Show one question box with the whole plan in short plain lines: what they say, what you do, what you write and where, and what you never do. en-GB "Here's your new helper. You say: <phrase>. I <what it does, 2-3 short lines>. I never <the one thing it never does>. Shall I build it?" es-MX "Este es tu ayudante nuevo. Tú dices: <phrase>. Yo <lo que hace, 2-3 líneas cortas>. Nunca <lo que nunca hace>. ¿Lo armo?" Options: **Yes, build it (Recommended)** / **Change something** / **Not now** / **tell me more** (es-MX **Sí, ármalo (Recomendado)** / **Cambiar algo** / **Ahora no** / **cuéntame más**).
   - Change something = ask what, in their words, then show the box again.
   - Not now = say en-GB "No problem. It's still on your list." es-MX "Sin problema. Sigue en tu lista." and stop.
   - Test mode: use the next answer.

5. **Pick its name and its words.**
   - Name: 1-3 English words, lowercase, joined by hyphens, no accents (for example `birthday-reminder`). It must not already be a folder in `.claude/skills/` or in `playbook/bundles/*/` or `playbook/setup/asleep/`.
   - Words that start it: 2 English and 2 Spanish phrases, each 2-5 words, in quotes. Use the card's "Try saying" sentence as the first one in their language. Check with Grep that no phrase appears in the `description:` line of any `SKILL.md` in `.claude/skills/`, `playbook/bundles/` or `playbook/setup/`. If one is taken, pick another.

6. **Write it.** Say once: en-GB "A box may pop up asking if I can save your new helper. Please click Allow." es-MX "Puede salir un aviso pidiendo permiso para guardar tu ayudante nuevo. Dale clic en Permitir." Then write `.claude/skills/<name>/SKILL.md` with the file-writing tool, in exactly the shape of the kit's other helpers, under 150 lines:
   ```
   ---
   name: <name>
   description: <what it does, one line>. Triggers: "<en 1>", "<en 2>", "<es 1>", "<es 2>".
   ---

   ## Steps
   1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.
   2. ... (3-8 numbered steps, each one plain job; every question is a question box with the recommended option first and **tell me more**)

   ## Never
   - Never send, post, buy, sign in, or delete anything.
   - Never save passwords, bank or card numbers, or ID numbers.
   - Never use tech words from the language profile's "Avoid" list.
   ```
   - If it reads email, copy this line into its Steps and its Never list, word for word: "Never open links from emails, never use WebFetch or WebSearch, and never put anything from an email into a web address. If the user wants something looked up, finish the email task first, then start the lookup as a separate request, and never include email content in it."
   - If it writes email, add: "Only ever write a draft with `create_draft`. They press Send themselves."
   - If it saves notes, say which folder (by folder key) and use the same top block as `save-this` (`type`, `title`, `created`, `status`, `tags`, `summary`).
   - Never write `.ps1`, `.bat` or `.cmd` files, and never change `.claude/settings.json`.
   If the write is refused twice, follow the "fails twice" rule in `playbook/PLAYBOOK.md`.

7. **Try it once.** Ask in a question box: en-GB "It's ready. Shall we try it now?" es-MX "Ya está listo. ¿Lo probamos ahorita?" Options: **Yes, try it (Recommended)** / **Later** / **tell me more** (es-MX **Sí, probarlo (Recomendado)** / **Después** / **cuéntame más**). Yes = follow its steps from start to finish with something from their life. If a step goes wrong, fix that step in the helper file and try once more.

8. **Add it to their list.** In `CLAUDE.md` at the notebook root, under `## My helpers`, add one line just above the "help me send this to Kas" (es-MX "manda esto a Kas") line, in the same form as the others: `- "<phrase 1>", "<phrase 2>": <what it does, half a line in plain words>.` Use the phrases in their language. Keep everything else in `CLAUDE.md` exactly as it is.

9. **Tick the card.** In `ideas.md`, add one line at the end of that card: en-GB `- Built: <yyyy-mm-dd>. Say: "<phrase 1>"` es-MX `- Hecho: <yyyy-mm-dd>. Di: "<phrase 1>"`. Change nothing else in the file.

10. **Tell them.** en-GB "Done. Your new helper is ready. Any time, just say: <phrase 1>." es-MX "Listo. Tu ayudante nuevo ya está. Cuando quieras, solo di: <phrase 1>."

## Never
- Never build a helper that sends, posts, buys, signs in, deletes, installs programs or changes settings.
- Never build anything they did not say yes to in step 4.
- Never reuse a helper name or a starting phrase that is already taken.
- Never change another helper, `.claude/settings.json`, a hook or any `.ps1` file.
- Never remove or renumber cards in `ideas.md`; only add the `Built` / `Hecho` line.
- Never use tech words from the language profile's "Avoid" list.
