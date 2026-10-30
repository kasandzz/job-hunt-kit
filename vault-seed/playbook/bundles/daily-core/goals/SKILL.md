---
name: goals
description: Show goals with their latest progress, log new progress and ask one gentle question about the next step. Triggers: "my goals", "update my goal", "mis metas", "actualiza mi meta".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.

2. **List.** Read every note in the `goals` folder from the language profile with `status: active`. For each, show one line: the goal and the last line of its "Progress log" with its date in words (for example "3 days ago"). Keep it to one screen.
   - No goal notes: say so kindly and offer to set one up in a question box: en-GB "You don't have a goal saved yet. Shall we write one down together?" es-MX "Todavía no tienes una meta guardada. ¿Escribimos una juntos?" Options: **Yes, one goal (Recommended)** / **Not now** / **tell me more** (es-MX **Sí, una meta (Recomendado)** / **Ahora no** / **cuéntame más**). A new goal uses `playbook/templates/goal.md`, file name `<two-to-five-words>.md` in lowercase with hyphens, and asks only "why it matters" and "a small first step".

3. **Pick.** If they named a goal, use it. Otherwise ask which one in a question box (en-GB "Which goal shall we look at?" es-MX "¿Cuál meta vemos?") listing up to 3 goals, plus **tell me more** (es-MX **cuéntame más**).

4. **Log progress.** Write their words as one new line at the bottom of "Progress log": `- <yyyy-mm-dd>: <what they did>`. Never rewrite older lines.
   - Finished: set `status: done` and add `- <yyyy-mm-dd>: done`. Celebrate in one warm line.
   - Want to stop it: set `status: paused` and add `- <yyyy-mm-dd>: paused`. No judgement.

5. **One gentle question.** At most one question box about the next small step (en-GB "What small step could come next?" es-MX "¿Qué pasito podría seguir?"), with 3 suggestions built from the goal's "First step" and recent progress, plus **tell me more** and **Not now** (es-MX **cuéntame más** and **Ahora no**). If they pick one, add it as `- <yyyy-mm-dd>: next: <step>`.

6. **Close** in one line: what you saved and where.

## Never
- Never ask more than one question about next steps.
- Never scold, compare them to others, or point out how long since the last update.
- Never delete a goal note; finished or stopped goals change `status:` only.
- Never rewrite or remove earlier progress lines.
- Never use tech words from the language profile's "Avoid" list.
