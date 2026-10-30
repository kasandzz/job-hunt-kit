---
name: tailored-cv
description: Tailor the user's CV to one job by changing only the emphasis, never inventing experience: agree a plan first, mark where every line comes from, follow the CV rules for their country and age, and list exactly what changed. Triggers: "tailor my CV", "adapt my CV", "adapta mi CV", "ajusta mi currículum".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md`, `playbook/profiles/access-gentle.md` and `playbook/setup/job-rules.md` (section 10, and `<jobs>/guide/`). Speak only in their language, in short lines. Never show a word from the "Avoid" list.

2. **Which job?** The job note in `<jobs>`. If unclear, a box with up to 2 open jobs from `_tracker.md`, plus **tell me more**. No job note: follow `job-tracker` to add it first.

3. **What we can use.** Only three sources, each line marked with where it comes from:
   - `<jobs>/cv-base.md` (`from: CV`). If it is missing, get it as area 1 of `playbook/profiles/mode-job-hunt.md` says (paste, photo, Drive or read aloud) and save it word for word.
   - `<jobs>/career-record.md`, confirmed facts only (`from: record`).
   - What they tell you now (`from: you said`).
   Read `<jobs>/corrections-log.md` and never repeat a mistake they already fixed.

4. **Match.** Compare what the job asks for with these sources: what the CV already shows, and what the job wants that it does not show. Use the "words to add" from the job's `## Fit` block if there is one.

5. **Gaps: ask, never fill.** For each important missing thing, one box: en-GB "Have you done anything like <thing>?" es-MX "¿Has hecho algo parecido a <thing>?" **Yes, let me tell you** / **No** / **tell me more** (es-MX **Sí, te cuento** / **No** / **cuéntame más**). Use only what they tell you. If they say no, leave it out.

6. **The plan first.** Show a short plan in a box, at most 8 lines: the order of the jobs, the 3-5 lines that go to the top, what gets shorter, and the opening profile in one sentence. en-GB "This is how I'd change it. Shall I go ahead?" es-MX "Así lo cambiaría. ¿Le sigo?" **Go ahead (Recommended)** / **Change the plan** / **tell me more** (es-MX **Adelante (Recomendado)** / **Cambiar el plan** / **cuéntame más**).

7. **Write `cv-<company>.md`** in `<jobs>` (company in lowercase with hyphens). Allowed changes only:
   - reorder sections and lines so the most relevant come first;
   - reword a line to use the advert's words for the same thing, keeping its strength: "helped with" stays "helped with", never "led"; "took part in" never becomes "managed";
   - a 2-3 line opening profile built only from the sources in step 3;
   - shorten or drop less relevant lines;
   - the country rules (section 10): for Mexico, the last 15 years in detail and older jobs in one short line, no graduation year unless recent, a photo only if they want one; for the UK, no photo and no date of birth. Never birth date, age, ID numbers or marital status.
   Keep each line's mark in a comment at the end of the line, like `<!-- from: CV -->`, so it can be checked. Same language as the base CV unless they ask otherwise. Set `cv_version: cv-<company>.md` in the job note.

8. **List what changed**, in a box: 3-8 short lines like "Moved your shop work to the top", "Used 'customer service' for 'helping people at the counter'". **Looks good (Recommended)** / **Change something** / **tell me more** (es-MX **Está bien (Recomendado)** / **Cambiar algo** / **cuéntame más**). For each change they ask for: fix it, and add a line to `<jobs>/corrections-log.md`: `- <yyyy-mm-dd>: <what was wrong> -> <what is right> (cv-<company>)`.

9. **Tell them** where it is saved, and that they can copy it into their own CV document. Then offer `job-apply`: **Help me apply (Recommended)** / **Not now** / **tell me more** (es-MX **Ayúdame a postularme (Recomendado)** / **Ahora no** / **cuéntame más**).

## Never
- Never invent a job, title, date, qualification, skill, number or result. If it is not in the three sources, it does not go in.
- Never change dates, employers, job titles or qualifications.
- Never make a line sound bigger than they said.
- Never use a fact from the internet they did not confirm.
- Never change, overwrite or delete `cv-base.md` or any Drive file; a new CV is always a new note.
- Never send or upload the CV anywhere.
- Never use tech words from the language profile's "Avoid" list.
