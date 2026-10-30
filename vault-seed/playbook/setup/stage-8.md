# Job-hunt setup: stage 8 extras (the daily job search)

Followed from step 4 of `playbook/stages/08-tour.md`. Instructions in English; everything they see is in their language, in five-year-old words. Read `playbook/setup/job-rules.md` (sections 7 and 8) and `<jobs>/search-profile.md` first.

## Steps
1. **Real phrases only.** For every helper you name, take the phrases from the `Triggers:` part of the `description:` line in `.claude/skills/<helper>/SKILL.md`. Never make one up.

2. **The time.** Use `time:` from the search profile; if it is `not set`, 8:00 is the best guess. Box: en-GB "Every day at <time>, I'll look for new jobs for you on my own. Is that time good?" es-MX "Todos los días a las <time> te busco trabajo yo solito. ¿Te queda bien esa hora?" **Yes, that time (Recommended)** / **Another time** / **tell me more** (es-MX **Sí, a esa hora (Recomendado)** / **Otra hora** / **cuéntame más**). Write the time into the search profile.

3. **Set up the daily search.** The task runs on this computer, in this notebook folder, once a day, with this text (always in English, the helper reads their language from the notebook):
   ```
   Daily job search. Follow .claude/skills/job-finder/SKILL.md in automatic mode. Nobody is at the computer: never ask a question, never apply, never send anything, never open the browser add-on. Write today's matches note, set last_run, and stop.
   ```
   - If you have a tool for scheduled tasks (its name has `scheduled_task` in it), use it: a task named `daily-job-search` that runs daily at the time from step 2, on this computer, in this notebook folder, with the text above. Say first: en-GB "A box may ask if I may set this up. Click Allow." es-MX "Puede salir un aviso que pregunta si puedo dejarlo listo. Dale clic en Permitir."
   - Otherwise, guide them through the clicks, one per line, waiting for "done" after each: en-GB "In the Claude app, click Code at the top." "On the left, click Scheduled." "Click New task." "Choose: only on this computer." "For the folder, pick your notebook folder, <notebook folder name>." "Choose Daily, and the time <time>." "Copy the text I show you, paste it in the big box, and click Create." es-MX "En la aplicación de Claude, dale clic en Code, arriba." "A la izquierda, dale clic en Scheduled (programadas)." "Dale clic en New task (tarea nueva)." "Escoge: solo en esta computadora." "En la carpeta, escoge la de tu cuaderno, <notebook folder name>." "Escoge Daily (diario) y la hora <time>." "Copia el texto que te enseño, pégalo en el cuadro grande y dale clic en Create (crear)." Show the text above in its own copy box.
   - Then: en-GB "Click Run now once. If a box asks for permission, choose the option that always allows it, so it never gets stuck when you're away." es-MX "Dale clic en Run now (correr ahora) una vez. Si sale un aviso de permiso, escoge el que dice que siempre lo permita, para que no se atore cuando no estés."
   Write `schedule: <time>` and `set_by: tool|clicks|not-set` in `playbook/state/job-runs.md`. If it could not be set up, write `set_by: not-set` and say: en-GB "That's fine. Every morning, when you say good morning, I'll look." es-MX "No pasa nada. Cada mañana, cuando me digas buenos días, yo busco."
   Test mode: never create a task. Write `schedule: <time>` and `set_by: skipped-test`, log `SKIPPED-TEST 8.4 daily job search task` in `playbook/state/test-log.md`, and carry on.

4. **Say the limit plainly.** en-GB "One thing to know: I can only look while the computer is on and the Claude app is open. If the computer is off at <time>, I look the next time you switch it on, or when you say good morning." es-MX "Algo que debes saber: solo puedo buscar si la computadora está prendida y la aplicación de Claude abierta. Si a las <time> está apagada, busco la siguiente vez que la prendas, o cuando me digas buenos días."

5. **Three things to say.** Say: en-GB "Here are three things you can say to me." es-MX "Estas son tres cosas que me puedes decir." Then three lines: "good morning" / "buenos días" (your day and your new jobs); the first phrase of `job-finder` ("looks for jobs right now"); the first phrase of `job-fit` ("tells you if a job is for you").
   Test mode: show everything above, ask nothing, and carry on with stage 8.

## Done when
- `playbook/state/job-runs.md` has `schedule:` and `set_by:`.
- They have heard the computer-off limit and three real phrases.
