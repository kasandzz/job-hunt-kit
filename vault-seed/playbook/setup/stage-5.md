# Job-hunt setup: stage 5 extras (the job helpers, and a first look at a job)

Followed from step 5 of `playbook/stages/05-bundles.md`, after the helpers are installed and listed. Instructions in English; everything they see is in their language, in five-year-old words. Read `playbook/setup/job-rules.md` first.

## Steps
1. **Group the job lines.** In `CLAUDE.md`, under `## My helpers`, move the lines for `job-profile`, `job-finder`, `job-fit`, `job-tracker`, `tailored-cv`, `cover-letter`, `interview-practice`, `company-brief`, `outreach-drafts`, `job-apply` and `career-record`, unchanged, under a sub-heading `### Mi búsqueda de trabajo` (en-GB `### My job search`), after the other helper lines and before the last three lines. Keep every other line exactly as it is.

2. **Say what they do, in three lines.** en-GB "I look for jobs for you every day." "I tell you which ones fit, and which ones look like a trick." "I get your CV ready, and I help you apply. Nothing goes without your two OKs." es-MX "Te busco trabajo todos los días." "Te digo cuáles te quedan y cuáles parecen trampa." "Te preparo tu currículum y te ayudo a postularte. Nada sale sin tus dos permisos."

3. **Link the job sites.** Read `country:` in `<jobs>/search-profile.md`. Which sites to offer (checked in Claude's connector list, 2026-10-30):
   - Indeed: country MX or UK. It is made by Indeed and Anthropic checked it; they sign in to Indeed, and it can only search jobs and read a job.
   - ZipRecruiter: country UK only (it is mainly for jobs in the US and UK); no sign-in.
   - Country LT: neither is offered (no Lithuanian Indeed or ZipRecruiter); write `not-offered` for both and skip the rest of this step.
   - Never offer Dice (US computer jobs only). LinkedIn and Glassdoor are not in the list; the job search tool covers them.
   Say once: en-GB "Some job sites can link to Claude, like your email did. Then I can search them for you directly." es-MX "Algunas páginas de empleo se pueden conectar con Claude, igual que tu correo. Así las reviso por ti directamente."
   For each site to offer, first a box: en-GB "Shall we link <site>? It takes a minute." es-MX "¿Conectamos <site>? Toma un minuto." **Yes, let's link it (Recommended)** / **Not today** / **tell me more** (es-MX **Sí, conéctalo (Recomendado)** / **Hoy no** / **cuéntame más**). Tell me more: en-GB "I can only search and read jobs there. I can't apply, send or change anything on that site." es-MX "Ahí solo puedo buscar y leer vacantes. No puedo postularme, enviar ni cambiar nada en esa página." Yes: one click per box, with **Done (Recommended)** / **Stuck** / **Explain more** (es-MX **Listo (Recomendado)** / **Me atoré** / **Explícame más**), the same way as step 2 of `playbook/stages/02-connect.md`:
   a. en-GB "In the Claude window, click your name or the circle with your first letter, bottom-left. Then click Settings." es-MX "En la ventana de Claude, dale clic a tu nombre o al circulito con tu inicial, abajo a la izquierda. Luego dale clic en Configuración (o Settings)."
   b. en-GB "On the left, click 'Connectors'. Then click 'Browse connectors'." es-MX "A la izquierda, dale clic en 'Connectors' (Conectores). Luego dale clic en 'Browse connectors' (Ver conectores)."
   c. en-GB "Type <site> in the search box. Click it, then click 'Connect'." es-MX "Escribe <site> en el buscador. Dale clic, y luego en 'Connect' (Conectar)."
   d. Indeed only: en-GB "An Indeed page opens. Sign in, or make a free Indeed account if you don't have one. Then click 'Allow'." es-MX "Se abre una página de Indeed. Entra con tu cuenta, o haz una cuenta gratis si no tienes. Luego dale clic en 'Permitir' (o Allow)." If they have no account and do not want one, record `skipped`; nothing breaks.
   e. en-GB "Now come back to the Claude window." es-MX "Ahora regresa a la ventana de Claude."
   On **Stuck**: a box with 3 likely answers (en-GB "I can't find it in the list" / "it asks for a password" / "an error message"; es-MX "no lo encuentro en la lista" / "me pide una contraseña" / "un mensaje de error"); after two misses offer **Skip for today** (es-MX **Hoy no**). Check quietly: a `search_jobs` tool with the site's name in it is there (if not yet, it shows after Claude is reopened; record `connected` and tell them it works from tomorrow). Never search with it here.
   Add to `playbook/state/connectors.md`, keeping the other lines: `indeed: connected | skipped | skipped-test | not-offered` and `ziprecruiter: connected | skipped | skipped-test | not-offered`. Skipped: en-GB "That's fine. Later just say: connect job sites." es-MX "No pasa nada. Después solo di: conecta páginas de empleo."
   Test mode: show no boxes and take no answers. Write `skipped-test` for each site that would be offered and `not-offered` for the rest, and log `SKIPPED-TEST 5.4 job site connect` in `playbook/state/test-log.md`.

4. **A first look at a job.** Box: en-GB "Shall I look for jobs for you right now?" es-MX "¿Te busco trabajo ahorita?" **Yes, look now (Recommended)** / **Not today** / **tell me more** (es-MX **Sí, busca ahorita (Recomendado)** / **Hoy no** / **cuéntame más**). Yes: follow `.claude/skills/job-finder/SKILL.md` (they are here, so not automatic mode), then offer `job-fit` for the best match.
   Test mode: do not search. Take the next answer from `playbook/test-answers.md`: it is the text of a job advert. Follow `.claude/skills/job-fit/SKILL.md` on that text, start to finish, taking any answers it needs from the test answers, and log `SKIPPED-TEST 5.5 live job search` in `playbook/state/test-log.md`.

5. **Carry on with stage 5.** Go back to `playbook/stages/05-bundles.md`, do its last step (Finish), and start the next stage in the same reply, the way `playbook/PLAYBOOK.md` says.

## Done when
- `CLAUDE.md` has the job search sub-heading under `## My helpers`.
- `playbook/state/connectors.md` has an `indeed:` and a `ziprecruiter:` line.
- One job was looked at with `job-fit`, or they chose "Not today".
