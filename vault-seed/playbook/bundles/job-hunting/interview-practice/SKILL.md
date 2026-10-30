---
name: interview-practice
description: Practise a job interview: 8 likely questions from the job note, asked one at a time with kind feedback on five points, building a bank of their true work stories, and ending with the 3 strongest answers saved. Triggers: "practise my interview", "practice my interview", "practicar entrevista", "practiquemos la entrevista".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md`, `playbook/profiles/access-gentle.md` and `playbook/setup/job-rules.md`. Speak only in their language, in short lines. Never show a word from the "Avoid" list.

2. **Which job?** The job note in `<jobs>`. If unclear, a box with up to 2 jobs from `_tracker.md`, plus **tell me more**. No job note: follow `job-tracker` first.

3. **Read** the job note, `<jobs>/companies/<company>.md` if there is one, `<jobs>/career-record.md`, `<jobs>/storybank.md` (write it from `playbook/setup/templates/storybank.md` if missing) and `cv-<company>.md` or `cv-base.md`.
   **Unfinished practice?** Find the latest `## Interview practice <date>` block in the job note. If it has no `### 3 answers to remember` yet and some `- Q<n>:` line has nothing after the `|`, offer: en-GB "Last time we stopped halfway. Shall we carry on?" es-MX "La vez pasada nos quedamos a la mitad. ¿Seguimos?" **Carry on (Recommended)** / **Start fresh** / **tell me more** (es-MX **Seguir (Recomendado)** / **Empezar de nuevo** / **cuéntame más**). Carry on = go to step 5 at the first unanswered question.

4. **Make 8 questions** from what the job asks, in the language the interview will likely be in: 1 "tell me about yourself"; 1 "why this job"; 3 "tell me about a time when..." tied to the advert; 1 strengths; 1 a tricky one (a gap, a change, or, for an older person, "how do you feel about working with younger people or new technology?"); 1 "do you have any questions for us?". Write all 8 under a new `## Interview practice <yyyy-mm-dd>` heading in the job note, one per line as `- Q<n>: <question> |`.
   Say: en-GB "I'll ask you 8 questions, one at a time. Answer as you would out loud. Press the Windows key and H together to talk. Say pause any time." es-MX "Te voy a hacer 8 preguntas, una por una. Contesta como lo harías en voz alta. Presiona la tecla de Windows y la H para hablar. Di pausa cuando quieras."

5. **One at a time.** "Question 3 of 8", then the question. Wait for the answer.

6. **Feedback on five points**, kind and short. Think through all five, then say only 3 lines:
   - **Substance:** is there a real example with a result?
   - **Shape:** what was happening, what they did, what came of it.
   - **Fit:** does it answer this question, for this job?
   - **Believable:** concrete and true, no big empty words.
   - **Their own:** something only they could say.
   Line 1: one thing that was good, quoting their words. Line 2: the one point to work on. Line 3: a stronger version in 2-3 sentences, built only from what they said and their notes.
   Box: **Next question (Recommended)** / **Try again** / **tell me more** (es-MX **Siguiente pregunta (Recomendado)** / **Intentar otra vez** / **cuéntame más**). "tell me more" also offers a pause.
   Straight away, without asking: write their answer in short after the `|`, and if it told a work story, add or update it in `storybank.md` with a strength: Strong, Good, Needs work, or Missing (no story yet for that kind of question).

7. **Finish.** Pick the 3 strongest answers. Show them as 3 "remember this" lines and add them under `### 3 answers to remember` in the same practice block. Say which kind of question has no story yet (Missing) and offer to find one next time. If the status is not `interview`, offer to set it.

8. **Close** with one warm line about something they did well.

## Never
- Never be harsh or discouraging; every feedback starts with something good.
- Never invent experience in the stronger version or the storybank.
- Never ask more than one question at a time.
- Never mention other apps or paid tools for interview practice.
- Never use tech words from the language profile's "Avoid" list.
