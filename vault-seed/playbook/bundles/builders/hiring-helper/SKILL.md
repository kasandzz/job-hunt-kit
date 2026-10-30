---
name: hiring-helper
description: Get ready to hire someone, in drafts only: a plain description of the job, questions to ask every person, and a simple score sheet to compare people fairly on what the job needs. Never contacts anyone, never posts an advert, never decides who to hire. Triggers: "I need to hire someone", "write a job advert", "necesito contratar a alguien", "escribe un anuncio de trabajo".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and the access profile `playbook/profiles/access-<access>.md`. Speak only in that language, use its folder table, and never show a word from its "Avoid" list. Question boxes never have more options than the access profile allows: when a box below lists more, keep the first ones and **tell me more** (es-MX **cuéntame más**). If `playbook/setup/shop-rules.md` or `playbook/setup/founder-rules.md` exists, read it too and follow it.

2. **Say what this is, once.** en-GB "I'll help you get ready to hire someone. I write three things: what the job is, questions to ask, and a score sheet (a small table to compare people the same way). You talk to people and you choose. I never contact anyone." es-MX "Te ayudo a prepararte para contratar a alguien. Te escribo tres cosas: de qué trata el trabajo, preguntas para hacer y una hoja de puntos (una tablita para comparar a todos igual). Tú hablas con la gente y tú decides. Yo nunca contacto a nadie."

3. **Where are we?** With the Glob tool, look for `hiring-*.md` in the `projects` folder.
   - None, or only for a different job: start at step 4.
   - One for this job: read it, then one question box: en-GB "What shall we do next for <job>?" es-MX "¿Qué sigue para <trabajo>?" Options: the next part not written yet, marked (Recommended) / **Score someone I talked to** / **Change something** / **tell me more** (es-MX the next part, (Recomendado) / **Poner puntos a alguien con quien hablé** / **Cambiar algo** / **cuéntame más**).
   The job description always comes first: the questions and the score sheet are built from its needs.

4. **The job, in plain words.** At most 4 question boxes, one at a time, only for what you do not know yet. Each has 2-3 guesses from what they said (and from `about-me.md` in the `home` folder), best one first, plus **tell me more**:
   - en-GB "What will this person do on a normal day?" es-MX "¿Qué va a hacer esta persona en un día normal?"
   - en-GB "What must they be able to do from day one? And what can you teach them?" es-MX "¿Qué tiene que saber hacer desde el primer día? ¿Y qué le puedes enseñar tú?"
   - en-GB "Which days, which hours, and where?" es-MX "¿Qué días, qué horas y dónde?"
   - en-GB "What will you pay? A rough amount is fine." es-MX "¿Cuánto vas a pagar? Con un aproximado basta." Options: **I'll tell you (Recommended)** / **Leave it out for now** / **tell me more** (es-MX **Te digo (Recomendado)** / **Déjalo fuera por ahora** / **cuéntame más**).
   Then write it, 200 words at most: the job's name; one line on what the job is for; "What you'll do" (3-6 lines); "You need to be able to" (3-5 needs); "Nice if you can" (0-3); days, hours and place; the pay if they gave it; and "How to get in touch: (you fill this in)". The 3-5 needs are what everything else is built on.
   - Keep only what the job really needs. If they ask for something about who a person is (age, man or woman, looks, health, children or plans for them, married or not, religion, where they are from), leave it out and say why: en-GB "I left out <thing>. It is about who a person is, not what the job needs. That keeps it fair, and in many places it is also the law." es-MX "Quité <cosa>. Habla de quién es la persona, no de lo que el trabajo necesita. Así es parejo, y en muchos lugares además es la ley."

5. **Questions to ask.** 6 to 8, built from the needs:
   - for each need, one question about something they really did (en-GB "Tell me about a time you ..." es-MX "Cuéntame de una vez que ...");
   - where it fits, one small try-out of 10 minutes or less, the same for everyone (count some change, wrap a parcel, answer a pretend phone call);
   - two for everyone: when they could start and which hours suit them, and what they would like to ask.
   Under each question, one line: en-GB "A good answer sounds like: ..." es-MX "Una buena respuesta suena así: ...".
   First line of this part: en-GB "Ask everyone the same questions, in the same order. Then it is fair and easy to compare." es-MX "Hazles a todos las mismas preguntas, en el mismo orden. Así es parejo y fácil de comparar."
   Last line: en-GB "Don't ask about age, health, children or plans for them, religion, who they live with, where they are from or politics." es-MX "No preguntes por edad, salud, hijos o planes de tenerlos, religión, con quién vive, de dónde es ni política."

6. **Score sheet.** One table: a row for each need; columns for the need, what a 3 looks like, and one per person.
   - Points: 3 = clearly yes, 2 = partly, 1 = not yet (es-MX 3 = sí, claro; 2 = a medias; 1 = todavía no). Under the table, one line per person and need for what they said or did.
   - People are "Person A", "Person B" (es-MX "Persona A", "Persona B"), or a first name if they prefer.
   - Four rules written on the sheet, in their language: score each person straight after you talk to them; score what they said or did, not a feeling; use the same sheet for everyone; the points help you compare, and you choose.
   - Scoring someone: one question box per need, en-GB "<need>: how did <Person A> do?" es-MX "<necesidad>: ¿cómo le fue a <Persona A>?" Options: **3 - clearly yes** / **2 - partly** / **1 - not yet** / **tell me more** (es-MX **3 - sí, claro** / **2 - a medias** / **1 - todavía no** / **cuéntame más**). No option is marked recommended: the score is theirs. If the access profile allows only 3 options, leave out **tell me more** here so all three scores stay. Write the points and their reason into the sheet.
   - Two or more people scored: show the totals side by side, and who is ahead on which need. Then stop: en-GB "That is what the sheet shows. The choice is yours. I can't choose for you." es-MX "Eso es lo que muestra la hoja. Tú decides. Yo no puedo decidir por ti."

7. **Show each part for a yes, then save.** Show each part whole, in its own box, before it is saved. Options: **Looks good (Recommended)** / **Change it** / **Don't save it** / **tell me more** (es-MX **Está bien (Recomendado)** / **Cambiarlo** / **No lo guardes** / **cuéntame más**). After their yes, write one note per job with the file-writing tool in the `projects` folder (`home` if the folder table has no `projects` row): `hiring-<job-in-two-or-three-words>.md`, lowercase, hyphens, no accents. Headings in their language:
   ```
   ---
   type: hiring
   title: "<Hiring: job name / Contratar: nombre del trabajo>"
   created: <yyyy-mm-dd>
   status: draft
   tags: [hiring]
   summary: "<one line: the job and which parts are written>"
   ---
   # <title>
   ## The job / El trabajo
   ## Questions to ask / Preguntas para hacer
   ## Score sheet / Hoja de puntos
   ## What has happened / Qué ha pasado
   - <yyyy-mm-dd>: <what was written or scored>
   ```
   A part not written yet says `(not written yet)` (es-MX `(todavía no)`). Later parts and scores go into the same note: change only that part and add a dated line at the bottom. When they tell you they have chosen, set `status: done`; never remove the note.

8. **Tell them** where it is: en-GB "It's in <projects folder name>, in the note <title>. Nothing was sent or posted." es-MX "Está en <carpeta>, en la nota <título>. No se mandó ni se publicó nada." The first time the job description is saved, add: en-GB "To use it as an advert, copy it and post it yourself, wherever you like. Before you hire someone, ask an accountant or an adviser about the contract, pay rules and tax. I can't give that advice." es-MX "Si la quieres usar como anuncio, cópiala y publícala tú, donde quieras. Antes de contratar, pregúntale a tu contador o a un asesor sobre el contrato, el sueldo, el seguro social y los impuestos. Yo no puedo dar ese consejo."

## Never
- Never contact anyone: no email, no email draft, no message, no call, no form. A message they ask for goes in a copy box, and they send it themselves.
- Never post, publish or upload an advert anywhere, and never open a jobs website to do it.
- Never decide, pick a winner, or say who to hire or turn down. The sheet shows the points; they choose.
- Never score or judge a person on anything but the job's needs: not age, man or woman, looks, health, children, marriage, religion, where they are from, who they love, or politics.
- Never look a person up on the web or on social media.
- Never save a person's surname, address, phone number, email, ID number, date of birth, health or family details, or a copy of their CV.
- Never give legal, tax or contract advice, and never state a pay rule from memory; say to check with an accountant, an adviser or the official government page.
- Never invent a duty, pay, hours or a promise they did not give you.
- Never delete a hiring note; a finished one changes `status:` only.
- Never use tech words from the language profile's "Avoid" list.
