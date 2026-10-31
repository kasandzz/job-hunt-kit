---
name: job-profile
description: Write or change what they are looking for (kinds of job, place, hours, lowest pay, languages, deal-breakers) in the search profile the job search uses. Also who presses the last button when applying, and linking job sites such as Indeed to Claude. Triggers: "my job search", "change what I'm looking for", "who presses submit", "connect job sites", "mi búsqueda de trabajo", "cambia lo que busco", "quién presiona el botón", "conecta páginas de empleo", "mano darbo paieška", "pakeisk, ko ieškau", "kas spaudžia mygtuką", "prijunk darbo svetaines".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md`, `playbook/profiles/access-gentle.md` and `playbook/setup/job-rules.md`. Speak only in their language, in short lines. Never show a word from the "Avoid" list.

2. **Read what we know.** `<jobs>/search-profile.md` if it exists; otherwise areas 4, 5 and 8 of `playbook/state/interview.md` and `<jobs>/career-record.md`.

3. **New or change?**
   - No `search-profile.md` yet: write it from `playbook/setup/templates/search-profile.md`, filled from step 2. Set `country: MX` if their language is es-MX, `UK` if en-GB, `LT` if lt-LT, unless they said they look for work in another of these countries. Search words: 2-6 short words for the jobs they want, in the language of the job sites they will use.
   - It exists: show it in 5 short lines (jobs, where, hours, pay floor, rules) and ask: en-GB "What shall we change?" es-MX "¿Qué cambiamos?" Options: **The jobs or the place (Recommended)** / **My rules or the pay** / **tell me more** (es-MX **Los trabajos o el lugar (Recomendado)** / **Mis reglas o el sueldo** / **cuéntame más**).

   - Only who presses the last button (a plain sentence like "I'll press Submit myself" / "you can press Submit", es-MX "yo presiono el botón" / "presiónalo tú"): if the sentence is clear, write `- submit: me` or `- submit: claude` under `## Applying` and say en-GB "Done. From now on, <you press it / I press it after your second OK>. On LinkedIn you always press it." es-MX "Listo. Desde ahora <lo presionas tú / lo presiono yo después de tu segundo permiso>. En LinkedIn siempre lo presionas tú." If it is not clear, ask the same box as area 8 of `playbook/profiles/mode-job-hunt.md`. Log it as step 6 says, then stop.

   - Only linking job sites ("connect job sites", "conecta páginas de empleo"): follow step 3 of `playbook/setup/stage-5.md` (Link the job sites), then stop.

4. **One thing at a time.** Ask about one item per question box, best guess first. Pay: ask per month in their money; "I'm not sure" is fine (write `pay floor: not sure`). Each deal-breaker is one short rule they agree with, in their words.

5. **Read back.** Show the 5 short lines again: en-GB "Is this right?" es-MX "¿Así está bien?" Options: **Yes (Recommended)** / **Change something** / **tell me more** (es-MX **Sí (Recomendado)** / **Cambiar algo** / **cuéntame más**).

6. **Save.** Write `search-profile.md` with `updated: <today>`. For each thing they changed, add a line to `<jobs>/corrections-log.md`: `- <yyyy-mm-dd>: <before> -> <after> (search-profile)`.

7. **Tell them** in one line: en-GB "Done. From tomorrow, I search with this." es-MX "Listo. Desde mañana busco con esto." Offer: **Search now (Recommended)** / **Not now** / **tell me more** (es-MX **Buscar ahora (Recomendado)** / **Ahora no** / **cuéntame más**). Search now = follow `job-finder`.

Test mode: take every answer from `playbook/test-answers.md`; never ask more than 3 questions here.

## Never
- Never add a rule, a job or a pay figure they did not say.
- Never set `submit: claude` unless they chose it in their own words.
- Never write ID numbers, passwords or bank details.
- Never delete `search-profile.md`; change it in place and log the change.
