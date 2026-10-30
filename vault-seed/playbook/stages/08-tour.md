# Stage 8: A short tour, then you're done

## Goal
The user leaves knowing five things to say tomorrow, how to pause and get help, and how the morning check-in reaches them. Setup ends here.

## Steps
1. **Five things to say tomorrow.** Read the "Trigger phrases" section of their language profile and the helpers that now exist in `.claude/skills/`. Pick the 5 most useful for this person (always include the morning check-in and "save this"), and show them as a short list of exact sentences they can type or say, each with half a line in plain words on what happens. Example en-GB: "good morning - I tell you what's new in your email and diary today." es-MX: "buenos días - te digo qué hay de nuevo en tu correo y tu agenda hoy." Use only phrases whose helper exists and whose connection is `connected` in `playbook/state/connectors.md`. Then one line about the week page: en-GB "In Obsidian, open the note called My week. It shows your last seven days and your goals on one page, and it fills itself in." es-MX "En Obsidian, abre la nota que se llama Mi semana. Ahí ves tus últimos siete días y tus metas en una sola página, y se llena solita."

2. **Pause and help.** Explain in short sentences: en-GB "If you need to stop, type pause. Everything is saved. Type carry on to pick up where you left off. If something ever goes wrong, type help me send this to Kas. I'll make a small file you can send him on WhatsApp. It never has your notes in it." es-MX "Si necesitas parar, escribe pausa. Todo queda guardado. Escribe seguimos para seguir donde te quedaste. Si algo sale mal, escribe manda esto a Kas. Yo hago un archivo chiquito que le puedes mandar por WhatsApp. Nunca lleva tus notas." Then one line about permission boxes: en-GB "Sometimes a box asks if I may do something. If I just told you why, click Allow. If you're not sure, click Deny; nothing breaks." es-MX "A veces sale un aviso preguntando si puedo hacer algo. Si yo te acabo de decir para qué, dale clic en Permitir. Si tienes duda, dale clic en Denegar; no se rompe nada."

3. **Morning check-in.** Read `playbook/state/phone.md`.
   - `mode: routine`: en-GB "Every morning at <time>, a check-in is ready for you in the Claude app on your phone. Open it, answer the three questions, and I'll save your answers." es-MX "Todas las mañanas a las <time>, tu plática de buenos días te espera en la app de Claude en tu celular. Ábrela, contesta las tres preguntas y yo guardo tus respuestas."
   - `mode: reminder` (or the file is missing): en-GB "Each morning at <time>, your phone will remind you. When it does, open Claude on the computer and say good morning." es-MX "Todas las mañanas a las <time>, tu celular te va a avisar. Cuando suene, abre Claude en la computadora y di buenos días."
   Use the time from `phone.md` and their time zone from `playbook/state/timezone.md`.

4. **Setup extras.** If `playbook/setup/stage-8.md` exists, follow every step in it now. If it does not exist, skip this step.

5. **Try something now.** Show a question box: en-GB "Anything you want to try right now? Pick one and we'll do it together." es-MX "¿Quieres probar algo ahorita? Escoge uno y lo hacemos juntos." Options: the morning check-in (Recommended); 2 more of the phrases from step 1 that suit them; **No, I'm done for today** (es-MX **No, ya terminé por hoy**). Do the one they pick, start to finish. Remember: you only write drafts, never send. Test mode: use the next answer.

6. **Finish.** Tell them warmly that setup is complete and their notebook is ready: en-GB "That's it. Your notebook is ready, and so am I. See you tomorrow morning." es-MX "Listo. Tu cuaderno ya está listo, y yo también. Nos vemos mañana en la mañana." Set `current_stage: 9` and `updated: <now, ISO 8601>` in `playbook/progress.md` and create `playbook/state/stage-8.done` (one line: the date and time). From now on, behave as their everyday helper using `CLAUDE.md`.

## Done when
- The user has seen the five sentences, the pause and help phrases, and how the morning check-in works.
- `playbook/progress.md` says `current_stage: 9`.
- `playbook/state/stage-8.done` exists.
