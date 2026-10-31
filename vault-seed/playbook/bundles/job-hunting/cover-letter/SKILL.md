---
name: cover-letter
description: Write a cover letter of 250 words or fewer for one job, from the job note and what we know about the user, shown for approval and saved next to the job note. Triggers: "cover letter", "write a cover letter", "carta de presentación", "escribe una carta de presentación", "motyvacinis laiškas", "parašyk motyvacinį laišką".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.

2. **Which job?** Find the job note in the `jobs` folder. If unclear, ask in a question box listing up to 3 open jobs from `_tracker.md`, plus **tell me more**. No job note yet: follow the `job-tracker` helper first.

3. **Gather.** Read the job note, `about-me.md` in the `home` folder ("Your days and work" and "Your life now" especially), and `cv-<company>.md` or `cv-base.md` in the `jobs` folder if they exist.

4. **One question, if needed.** If there is no clear reason why they want this job, ask one question box: "What draws you to this job?" ("¿Qué te atrae de este trabajo?") with 3 guesses from about-me plus **tell me more** (es-MX **cuéntame más**).

5. **Write the letter.** 250 words maximum (count them; trim if over). Language: the language of the job advert. Shape:
   - a greeting (the named person if the advert gives one);
   - why this job and this company, in one or two sentences;
   - two short paragraphs linking real things from their CV or about-me to what the advert asks for;
   - a warm, simple close and their first and last name if known.
   Plain and sincere; no clichés like "I am writing to express my interest".

6. **Show it in a box**, the full text exactly as it will be saved, with the word count. Options: **Looks good (Recommended)** / **Change it** / **Cancel** (es-MX **Está bien (Recomendado)** / **Cambiarla** / **Cancelar**). Change it = ask what, rewrite, show the whole letter again.

7. **Save** after "Looks good" as `cover-letter-<company>.md` in the `jobs` folder, next to the job note (top: `type: cover-letter`, `title`, `created`, `status: final`, `tags: [cover-letter]`, `summary`). If one already exists for this company, save the new one as `cover-letter-<company>-2.md`. Add a dated line to the job note: `- <yyyy-mm-dd>: cover letter written`.

8. **Tell them** where it is saved and that they can copy it into their application.

9. **Emailing it (only if they ask).** This is a new email, not a reply, so do not use the `draft-reply` steps.
   - The advert gives an email address to apply to, and `gmail: connected` in `playbook/state/connectors.md`: show a question box with `To: <that address>`, `Subject: <role> - <their name>` and the full letter as the email text. Options: **Looks good (Recommended)** / **Change it** / **Cancel**. After "Looks good", use `create_draft` with `to` set explicitly to `["<that address>"]`, never their own address and never empty. Then say: "It's in your Drafts, the folder in Gmail where unsent emails wait. Add your CV to it (the paperclip button), then press Send in Gmail when you're happy." ("Está en tus Borradores, la carpeta de Gmail donde esperan los correos sin mandar. Agrégale tu CV (el botón del clip) y presiona Enviar en Gmail cuando quieras.")
   - No address in the advert, or Gmail not connected: tell them kindly to copy the letter into their own email or the form on the job website.

## Never
- Never go over 250 words.
- Never invent experience, skills, qualifications or reasons; everything comes from the job note, the CV, about-me or their answer.
- Never send or upload it; an email draft only when they ask, only as in step 9, and never with `update_draft`.
- Never guess an employer's email address; use only one written in the advert.
- Never overwrite or delete an earlier letter.
- Never use tech words from the language profile's "Avoid" list.
