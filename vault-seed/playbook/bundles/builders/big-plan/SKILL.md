---
name: big-plan
description: Turns one big thing they want to do (move house, a wedding, a trip, starting something new) into a clear plan with small steps, and keeps track of where they are. It is the plain-words front door to the planning tool in the notebook, so they never type a command. Triggers: "I have a big thing to plan", "help me plan something big", "tengo algo grande que planear", "ayúdame a planear algo grande".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and the access profile `playbook/profiles/access-<access>.md`. Speak only in that language, use its folder table, and never show a word from its "Avoid" list. Question boxes never have more options than the access profile allows. If `playbook/setup/shop-rules.md` or `playbook/setup/founder-rules.md` exists, read it too and follow it.

2. **Is the planning tool here?** Read `.claude/get-shit-done/VERSION` with the Read tool.
   - It is there: use the tool's files as your recipe book (step 3).
   - It is missing: do not stop and do not say anything is broken. Make the plan the simple way: follow the `project-builder` helper's steps and save one plan note. At the end add one line: en-GB "Kas can add a bigger planning tool later if you want more detail. Type help me send this to Kas." es-MX "Kas puede poner después una herramienta de planes más completa. Escribe manda esto a Kas." Then stop.

3. **How to use the recipe book.** The tool lives in `.claude/get-shit-done/`. Its `workflows/` files say what to do at each step, and its `templates/` files give the shape of each plan file. Read only the one workflow file for the step you are on. Follow what it asks for, with these fixed changes:
   - You write every plan file yourself with the file-writing tool, in the folder `.planning/` at the notebook root, using the tool's templates. Never run a command to do it: skip every line that runs `node`, `gsd-tools`, `git`, `mkdir`, `cat` or any other command, and skip every step about models, branches, commits, "agents", research teams or code.
   - Where a workflow hands work to another agent, do that thinking yourself, briefly.
   - Every question follows this notebook's rules: one clickable box at a time, the recommended answer first, plain words, in their language. Never show the tool's own words to them: say "your plan", "steps", "what done looks like", never "phase", "milestone", "requirements", "roadmap", "GSD" or a slash command.
   - Write `.planning/config.json` from `templates/config.json` once, with `"mode": "interactive"`, `"granularity": "coarse"`, `workflow.research` false, `workflow.plan_check` false, `planning.commit_docs` false and `parallelization.enabled` false. Never ask them about these.
   - Plan file text is in their language; keep the tool's headings and top block keys as the templates have them.

4. **Where are we?** Look for `.planning/STATE.md`.
   - Not there: this is a new big thing. Go to step 5.
   - There, and the plan is not finished: tell them in one line what the plan is and what the next step is (read `.planning/STATE.md` and `.planning/ROADMAP.md`; `workflows/progress.md` shows how to read them). Question box: en-GB "You already have a big plan going: <name>. Next up: <next step>. What shall we do?" Options: **Carry on with it (Recommended)** / **Plan a different thing** / **tell me more**. es-MX "Ya tienes un plan grande en marcha: <name>. Lo que sigue: <next step>. ¿Qué hacemos?" Options: **Seguir con ese (Recomendado)** / **Planear otra cosa** / **cuéntame más**. Carry on = step 7. A different thing = say kindly that one big plan at a time works best, and offer a one-page plan for the new thing with the `project-builder` helper.
   - There, and every step is done: follow `workflows/complete-milestone.md` (write its summary files with the file-writing tool; never remove or move anything, leave the old step folders where they are). Then the new big thing starts with `workflows/new-milestone.md` in place of `new-project.md` in step 5.

5. **Understand the big thing.** Follow the "Deep Questioning" part of `workflows/new-project.md`, as a friendly chat: what it is, why it matters to them, who else is in it, when it needs to happen, what would make it feel done, what worries them, what is not part of it. Use what you already know from `about-me.md` in the `home` folder; never ask again for something they told you there. At most 6 boxes. Then write `.planning/PROJECT.md` from `templates/project.md`.

6. **Make the plan.** Follow "Define Requirements" and "Create Roadmap" in `workflows/new-project.md`:
   - `.planning/REQUIREMENTS.md` from `templates/requirements.md`: the short list of what must be true for it to be done.
   - `.planning/ROADMAP.md` from `templates/roadmap.md`: 3 to 6 steps in order, each with a plain name and "you'll know it's done when...".
   - `.planning/STATE.md` from `templates/state.md`: which step they are on.
   Read the steps back in plain words and ask: en-GB "Here are the steps, in order: <steps>. Does that look right?" Options: **Yes, that's it (Recommended)** / **Change something** / **tell me more**. es-MX "Estos son los pasos, en orden: <steps>. ¿Así está bien?" Options: **Sí, así (Recomendado)** / **Cambiar algo** / **cuéntame más**.
   Then write the plan page they can see (step 9) and offer to start step 1 now or another day.

7. **Work on one step.** For the step they are on:
   a. Talk it through with `workflows/discuss-phase.md` (2-4 boxes about the choices only they can make). Save `.planning/phases/<nn>-<slug>/<nn>-CONTEXT.md` from `templates/context.md`.
   b. Break it into small jobs with `workflows/plan-phase.md`. Save `<nn>-01-PLAN.md` in the same folder from `templates/phase-prompt.md`. Each job is marked `mine` (something you can do in the notebook: a list, a comparison, a draft, a note) or `yours` (anything out in the world: a phone call, a visit, a payment, a booking, a signature).
   c. Do the `mine` jobs now, the way `workflows/execute-plan.md` describes, one at a time. Drafts stay drafts. Show each result in two lines.
   d. List the `yours` jobs as a short to-do list in the plan page (step 9). Never do them for the person.
   e. Write `<nn>-01-SUMMARY.md` from `templates/summary.md` with what got done.

8. **Check the step.** When they say a step is finished, or all its jobs are ticked: follow `workflows/verify-work.md` as two or three plain yes/no boxes ("Is the van booked?"). All yes: mark the step done in `.planning/ROADMAP.md` and move `.planning/STATE.md` to the next step. A no: add that job back to the to-do list, with no blame.

9. **The plan page they can see.** Folders that start with a dot do not show in Obsidian, so keep one page in the `projects` folder: `plan-<short-name>.md`, written with the file-writing tool and updated every time something changes:
   ```
   ---
   type: big-plan
   title: "<name of the big thing>"
   created: <yyyy-mm-dd>
   status: active
   tags: [big-plan]
   summary: "<one line: what it is and which step they are on>"
   ---
   ```
   then, in their language: why it matters (2 lines), the steps as a tick list (done ones ticked), "Your to-do list" (the `yours` jobs for the current step), and "What I did for you" (links to the notes and drafts you made). When the last step is done, set `status: done`.

10. **Wrap up.** Every time, end with one line on where things stand and the phrase to come back: en-GB "Your plan is in the <projects folder> folder, in the note <title>. Say help me plan something big any time and we'll carry on." es-MX "Tu plan está en la carpeta <projects folder>, en la nota <title>. Di ayúdame a planear algo grande cuando quieras y seguimos." If the `notebook-guide` helper is installed, refresh the notebook guide note as it describes.

## Never
- Never type, show or suggest a slash command, and never tell them to open the planning files.
- Never run the tool's update, remove, clean-up, undo or "ship" steps, and never delete, move or overwrite a plan file from an earlier plan.
- Never do a `yours` job: no buying, booking, paying, sending, posting or signing in their name. Email is draft-only, and `playbook/browser.md` holds in a web browser.
- Never put passwords, bank or card numbers, or ID numbers in a plan file.
- Never plan something that needs a professional (legal, medical, tax, money advice) without saying plainly that they should check with one.
- Never have more than one big plan open at a time.
