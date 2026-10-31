# Stage 3: Getting to know you

## Goal
A warm, private conversation across 8 areas of their life, so the notebook and helpers fit them. Every finished area is saved as it ends, so a pause never loses anything and no area is ever asked twice. The user should feel listened to, never examined.

## Steps
1. **Opening.** Read `playbook/state/connectors.md`. Say this exactly, in their language, with `<what>` chosen from what is `connected`:
   - en-GB: "Nobody else reads this, not even Kas. To ask better questions, I'll take a quick look at <what> only. Skip anything. Say pause any time."
     `<what>`: Calendar and Gmail both connected = "your calendar and the subjects of your emails"; only Calendar = "your calendar"; only Gmail = "the subjects of your emails".
   - es-MX: "Nadie más lee esto, ni siquiera Kas. Para hacerte mejores preguntas, voy a echarle un ojo solo a <what>. Sáltate lo que quieras. Di pausa cuando quieras."
     `<what>`: los dos = "tu calendario y los asuntos de tus correos"; solo Calendar = "tu calendario"; solo Gmail = "los asuntos de tus correos".
   If neither Gmail nor Calendar is `connected`, leave out the second sentence (it would not be true).
   If `interview_area_done` in `playbook/progress.md` is above 0, this is a return visit: skip the opening and say only "Welcome back. Let's carry on where we stopped." ("Qué gusto verte. Seguimos donde nos quedamos.")
   If the access profile's "Answer style" asks for it, remind them once in one sentence that they can talk instead of typing (en-GB "Remember, you can press the Windows key and H together and just talk." es-MX "Acuérdate: puedes presionar la tecla de Windows y la H al mismo tiempo y solo hablar.").

2. **A quiet look, read-only.** Only for connections marked `connected` in `connectors.md`: list the next 14 days of calendar events and the last 30 email subjects (subjects only, never open a message body). Use them only to choose better answer options (for example, a run of appointments suggests asking about health or busy weeks; school emails suggest asking about children).
   - Never quote an email subject or event back to them, never name who an email is from, and never write any of it into a file.
   - Never open links from emails, never use WebFetch or WebSearch, and never put anything from an email into a web address. If the user wants something looked up, finish the email task first, then start the lookup as a separate request, and never include email content in it.
   - Test mode or `skipped`: skip this step.

3. **The interview.** Work through the areas from `interview_area_done + 1` up to 8, in order. Never repeat an area already done. For each area:
   a. **Resume check.** If `playbook/state/interview.md` already has a `## Area N` heading for this area, it was saved just before a stop: set `interview_area_done: N` (and `updated:`) in `progress.md`, overwrite `interview-current.md` with `area: none`, and move to the next area.
   b. **Half-finished area.** If `playbook/state/interview-current.md` says `area: N`, read the answers already in it and continue from the next unasked question (if it also says `optin: little`, keep to 2-3 questions in total for this area). Otherwise overwrite it with `area: N` on the first line.
   c. **Opt-in for areas 4 and 5.** Open with a question box that says in one plain line what the area is about, then asks: en-GB "Would you like to talk about this? It's fine to say no." es-MX "¿Quieres platicar de esto? Está bien decir que no." Options: **Yes (Recommended)** / **Just a little** / **Skip** (es-MX **Sí (Recomendado)** / **Solo un poco** / **Saltar**). "Just a little" = 2-3 gentle questions only; write `optin: little` as the second line of `interview-current.md` so a resumed sitting keeps to that. "Skip" = save the area at once as `Skipped by choice.` and move on. Never push.
   d. **Questions.** Ask 6-10 questions, one at a time, each in a question box with the number of options the access profile's "Options per question" says (3-4 options, best guess first, plus **tell me more** (es-MX **cuéntame más**) so they can type freely). Each question text makes sense on its own: one short question, everyday words, no "and also" second question tucked inside. Build each next question on what they just said. After each answer, append one line `- <question in short>: <their answer in their words>` to `interview-current.md`.
      Test mode: ask exactly 6 questions per area (2 for "Just a little") and take every answer from `playbook/test-answers.md`.
   e. **Read back.** Show a question box with a 3-line summary of the area in their words, then: en-GB "Did I get this right?" es-MX "¿Lo entendí bien?" Options: **Yes (Recommended)** / **Almost, let me fix something** / **tell me more** (es-MX **Sí (Recomendado)** / **Casi, déjame corregir algo** / **cuéntame más**). Fix and show again if needed.
   f. **Save, in this order.** First append to `playbook/state/interview.md`:
      ```
      ## Area N - <area name in English>
      summary: <the 3 agreed lines, in their language>
      <the answer lines from interview-current.md>
      ```
      Then set `interview_area_done: N` and `updated: <now, ISO 8601>` in `playbook/progress.md`, then overwrite `interview-current.md` with `area: none`. Only then move on. Each `## Area N` heading appears once in the file, ever.
   g. **Breaks.** After areas 2, 4 and 6, offer a break as the access profile's "Sitting length" says: en-GB "Everything so far is saved. Shall we keep going, or stop here for now?" es-MX "Todo lo que llevamos ya está guardado. ¿Seguimos o paramos aquí por ahora?" Options: **Keep going (Recommended)** / **Pause here** / **tell me more** (es-MX **Seguimos (Recomendado)** / **Paramos aquí** / **cuéntame más**). Pause here = do the pause from `PLAYBOOK.md`.
   Privacy, every area: never write passwords, bank or card numbers, or ID numbers into any file, even if they say them; write `(private, not saved)` instead (es-MX exactly `(privado, no guardado)`, lt-LT exactly `(privatu, neišsaugota)`). Health and worries details are written only in `interview.md`. Other files get only what the user asked help with (for example a reminder), never the details.

4. **Areas and starter questions.** Use these as the first question or two, then follow their answers.
   If `playbook/profiles/mode-<mode>.md` has a `## Interview areas` section, use its 8 areas and starter questions instead of the list below: same numbers, same rules, and an area it marks `no opt-in` skips step 3c. Otherwise use this list.
   1. **Life now:** a typical weekday; what drains them; what delights them. Include one question on how they like you to talk to them (short and to the point / chatty and warm / tell me more) and one on what annoys them in a helper. Stage 4 needs these.
   2. **Dreams:** where they would love to be in 5 years; what they would do if money was no object.
   3. **Goals:** 1-3 goals for this year; 1-3 for this month. For each, ask why it matters and one small first step. Stage 4 makes one note per goal.
   4. **Worries and risks** (opt-in): what keeps them up at night; what they would like help keeping an eye on.
   5. **Health and energy** (opt-in): energy across the day; sleep; anything they want reminders for (appointments, medicines, walks).
   6. **People:** who matters most; who they want to stay close to; birthdays they never want to miss. For each person, record first name, relationship, birthday if known, and one thing to remember. Stage 4 makes one note per person.
   7. **The focus from the mode profile:** read `## Interview area 7 focus` in `playbook/profiles/mode-<mode>.md` and ask about that.
   8. **Hobbies and learning:** books they are reading or want to read; videos and channels they enjoy; topics they want to learn about.

5. **Seeds and deeper questions.** After area 8 is saved:
   - Write `playbook/state/seeds.md`: 10-30 one-line needs you heard, each tagged with its area, for example `- [area 6] Remind me two weeks before Ruth's birthday so I can post a card.`
   - Write `playbook/state/deeper-questions.md`: exactly 30 numbered questions, in their language, each going one step deeper on something they said, in this form: `1. [ ] (area 2) <question>`. The morning check-in uses one a day and ticks it `[x]`.
   - Never put health details into `seeds.md` beyond what they asked help with.

6. **Thank them.** One or two warm sentences: en-GB "Thank you for sharing all that with me. Next I'll make your notebook from what you told me." es-MX "Gracias por contarme todo esto. Ahora armo tu cuaderno con lo que me platicaste."

7. **Finish.** When everything under "Done when" is true, create `playbook/state/stage-3.done` (one line: the date and time), set `current_stage: 4` and `updated: <now>` in `playbook/progress.md`, and move on to stage 4 in the same sitting unless they typed pause.

## Done when
- `playbook/progress.md` says `interview_area_done: 8`.
- `playbook/state/interview.md` has exactly one `## Area N` heading for each of 1 to 8.
- `playbook/state/seeds.md` and `playbook/state/deeper-questions.md` (30 questions) exist.
- `playbook/state/stage-3.done` exists.
