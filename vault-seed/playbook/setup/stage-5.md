# Job-hunt setup: stage 5 extras (the job helpers, and a first look at a job)

Followed from step 5 of `playbook/stages/05-bundles.md`, after the helpers are installed and listed. Instructions in English; everything they see is in their language, in five-year-old words. Read `playbook/setup/job-rules.md` first.

## Steps
1. **Group the job lines.** In `CLAUDE.md`, under `## My helpers`, move the lines for `job-profile`, `job-finder`, `job-fit`, `job-tracker`, `tailored-cv`, `cover-letter`, `interview-practice`, `company-brief`, `outreach-drafts`, `job-apply` and `career-record`, unchanged, under a sub-heading `### Mi búsqueda de trabajo` (en-GB `### My job search`), after the other helper lines and before the last three lines. Keep every other line exactly as it is.

2. **Say what they do, in three lines.** en-GB "I look for jobs for you every day." "I tell you which ones fit, and which ones look like a trick." "I get your CV ready, and I help you apply. Nothing goes without your two OKs." es-MX "Te busco trabajo todos los días." "Te digo cuáles te quedan y cuáles parecen trampa." "Te preparo tu currículum y te ayudo a postularte. Nada sale sin tus dos permisos."

3. **A first look at a job.** Box: en-GB "Shall I look for jobs for you right now?" es-MX "¿Te busco trabajo ahorita?" **Yes, look now (Recommended)** / **Not today** / **tell me more** (es-MX **Sí, busca ahorita (Recomendado)** / **Hoy no** / **cuéntame más**). Yes: follow `.claude/skills/job-finder/SKILL.md` (they are here, so not automatic mode), then offer `job-fit` for the best match.
   Test mode: do not search. Take the next answer from `playbook/test-answers.md`: it is the text of a job advert. Follow `.claude/skills/job-fit/SKILL.md` on that text, start to finish, taking any answers it needs from the test answers, and log `SKIPPED-TEST 5.5 live job search` in `playbook/state/test-log.md`.

4. **Carry on with stage 5.** Go back to `playbook/stages/05-bundles.md`, do its last step (Finish), and start the next stage in the same reply, the way `playbook/PLAYBOOK.md` says.

## Done when
- `CLAUDE.md` has the job search sub-heading under `## My helpers`.
- One job was looked at with `job-fit`, or they chose "Not today".
