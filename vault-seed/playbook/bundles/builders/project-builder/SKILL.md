---
name: project-builder
description: Turn one thing they want to do into a short project note: the goal in one line, the steps in order, the very next small step, and a date if they have one. Asks at most 3 questions. Triggers: "start a project", "new project note", "empieza un proyecto", "nota de proyecto nueva".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and the access profile `playbook/profiles/access-<access>.md`. Speak only in that language, use its folder table, and never show a word from its "Avoid" list. Question boxes never have more options than the access profile allows: when a box below lists more, keep the first ones and **tell me more** (es-MX **cuéntame más**). If `playbook/setup/shop-rules.md` or `playbook/setup/founder-rules.md` exists, read it too and follow it.

2. **What is it?** Take the thing from what they said (for example "I want to paint the spare room"). Do not make them say it again.
   - With the Glob tool, look in the `projects` folder for a note about the same thing. If there is one, go to step 8.
   - Work out which kind of thing it is yourself, so nothing is kept in two places. Do not ask:
     - one small job, done in one go: not a project. Save it as a task the way the `save-this` helper does, and say so in one line.
     - something with no end that they want to keep doing or get better at (walk more, learn English): that is a goal. Follow the `goals` helper.
     - something with an end and a few steps: a project. Carry on here. When you are not sure, it is a project.

3. **Ask at most 2 things**, one question box each, and only what you do not already know from this chat or from `about-me.md` in the `home` folder:
   - Finished: en-GB "How will you know it's done? What will be true that day?" es-MX "¿Cómo vas a saber que ya quedó? ¿Qué va a ser cierto ese día?" Options: 2-3 endings built from their own words, best one first, plus **tell me more**.
   - A day: en-GB "Is there a day it has to be done by?" es-MX "¿Hay un día para el que tiene que estar listo?" Options: the day they hinted at, if any, first; then **No date** / **Another day** / **tell me more** (es-MX **Sin fecha** / **Otro día** / **cuéntame más**). With no hint, **No date (Recommended)** (es-MX **Sin fecha (Recomendado)**) goes first.
   The third and last question is the box in step 5. Never ask a fourth: work the rest out yourself.

4. **Work out the note**, in their language, in plain words:
   - **The goal:** one line, 15 words at most, starting with a doing word.
   - **Done when:** one line they could answer with yes or no.
   - **Steps:** 3 to 7, in order. Each is one small job and starts with a doing word.
   - **Next step:** the first step, made small enough to do today in about half an hour. If the first step is bigger, cut it down ("Get a price from two painters" becomes "Find the phone numbers of two painters").
   - **The day:** only the one they gave. No day given = no day anywhere in the note. Never work one out for them.

5. **Show it for a yes, in its own box.** The box text holds the goal, done when, the steps, the next step and the day, in short lines. en-GB "Here is your project. Does it look right?" es-MX "Este es tu proyecto. ¿Así está bien?" Options: **Yes, save it (Recommended)** / **Change something** / **Don't save it** / **tell me more** (es-MX **Sí, guárdalo (Recomendado)** / **Cambiar algo** / **No lo guardes** / **cuéntame más**). Change something is their choice, so it is not a new question of yours: ask what, fix it, show the whole box again. Don't save it = stop; nothing is saved.

6. **Save it** only after "Yes, save it", with the file-writing tool, in the `projects` folder (if the folder table has no `projects` row, use `home`). File name: `<two-to-five-words>.md`, lowercase, words joined by hyphens, no accents (for example `paint-the-spare-room.md`). If that name is taken, add `-2`; never overwrite. Headings in their language:
   ```
   ---
   type: project
   title: "<the thing, in a few words>"
   created: <yyyy-mm-dd>
   status: active
   tags: [project]
   summary: "<the goal in one line>"
   due: <yyyy-mm-dd; leave this line out when they gave no day>
   ---
   # <title>
   **The goal / Lo que quiero lograr:** <one line>
   **Done when / Queda listo cuando:** <one line>
   **By / Para el:** <the day in words; leave this line out when there is none>

   ## Next step / Siguiente paso
   <the one small thing>

   ## Steps / Pasos
   - [ ] <step>

   ## How it's going / Cómo va
   - <yyyy-mm-dd>: <started / empezado>
   ```

7. **Tell them** in two lines: en-GB "Saved in <projects folder name>: <title>. Your next step: <next step>." es-MX "Guardado en <carpeta>: <título>. Tu siguiente paso: <siguiente paso>." Only if the thing is very big (more than 7 steps, or it will take many months), add one line: en-GB "If this grows, say help me plan something big and we'll make a fuller plan." es-MX "Si esto crece, di ayúdame a planear algo grande y armamos un plan más completo."

8. **A project they already have.** Read the note and tell them in one line where it stands. Then, from what they said:
   - They did a step: tick it (`- [x]`), add `- <yyyy-mm-dd>: <what they did>` under "How it's going", and write the next unticked step under "Next step", cut small as in step 4.
   - A new step, or a new day: add it, and add a dated line saying so. Never rewrite older lines under "How it's going".
   - Every step ticked: set `status: done`, add `- <yyyy-mm-dd>: done`, and say one warm line.
   - They want to stop: set `status: paused` and add `- <yyyy-mm-dd>: paused`. No judgement.
   Close in one line with the next step.

## Never
- Never ask more than 3 questions before the note is saved, counting the box in step 5.
- Never save a project note before they say yes to it.
- Never make up a day, a price, a name or a promise. No day given means no day.
- Never do a step out in the world for them: no buying, booking, paying, sending, posting or signing up. This helper only writes notes.
- Never delete or overwrite a project note; a finished or stopped one changes `status:` only.
- Never write passwords, bank or card numbers, or ID numbers into a note.
- Never scold or point out how long a project has been waiting.
- Never use tech words from the language profile's "Avoid" list.
