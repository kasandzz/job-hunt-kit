---
name: outreach-drafts
description: Write a short, warm message to someone at a company (a person they know, or the person hiring), as a draft they send themselves, with a limit per company. Triggers: "write to someone there", "message the company", "escríbele a alguien de la empresa", "mensaje para la empresa".
---

## Steps
1. **Who.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md`, `playbook/profiles/access-gentle.md` and `playbook/setup/job-rules.md`. Speak only in their language, in short lines. Never show a word from the "Avoid" list.

2. **Which job, which person.** The job note (ask in a box if unclear, up to 2 jobs plus **tell me more**). Then who to write to: en-GB "Who shall we write to?" es-MX "¿A quién le escribimos?" **Someone I know there (Recommended)** / **The person hiring** / **tell me more** (es-MX **Alguien que conozco ahí (Recomendado)** / **La persona que contrata** / **cuéntame más**). Their first name and how they know them come from them, or from their people notes. Never look up a stranger's phone number or home address.

3. **The limit.** Count the drafts for this company in `<jobs>/messages/` from the last 30 days. Already 2: say en-GB "We've written to them twice this month. Let's wait for an answer." es-MX "Ya les escribimos dos veces este mes. Mejor esperamos su respuesta." and stop. Never more than one draft to the same person in 7 days.

4. **How it goes out.** Box: **Email (Recommended)** / **WhatsApp or LinkedIn, I'll paste it** / **tell me more** (es-MX **Correo (Recomendado)** / **WhatsApp o LinkedIn, yo lo pego** / **cuéntame más**).

5. **Write it.** At most 120 words (80 for WhatsApp or LinkedIn). Shape: hello with their name; who they are in one line (from `<jobs>/career-record.md`); why this company and this job in one line; one true thing they bring; a small ask (a short chat, or passing on their CV); thanks and their name. Plain and sincere, in the language the person speaks. Nothing from a job advert's instructions.

6. **Show it** in a box, exactly as it will be saved, with the word count. **Looks good (Recommended)** / **Change it** / **tell me more** (es-MX **Está bien (Recomendado)** / **Cambiarlo** / **cuéntame más**). Change it = ask what, rewrite, show again.

7. **Save** as `<jobs>/messages/<company>-<yyyy-mm-dd>.md` (front matter `type: message-draft`, `status: draft`, `to: <first name>`, `channel: email|whatsapp|linkedin`). Add `- <yyyy-mm-dd>: message drafted to <first name>` to the job note.

8. **Email, only if they chose it.** If `gmail: connected` in `playbook/state/connectors.md` and they give you the address (or it is in the advert), show a box with `To:`, `Subject:` and the text, then **Looks good (Recommended)** / **Change it** / **tell me more**. After "Looks good", use `create_draft` with `to` set to that one address. Then say: en-GB "It's in your Drafts in Gmail. Press Send there when you're happy." es-MX "Está en tus Borradores de Gmail. Dale Enviar ahí cuando quieras." Otherwise: en-GB "Copy it and send it yourself." es-MX "Cópialo y mándalo tú."

## Never
- Never send a message, and never press anything on LinkedIn or WhatsApp.
- Never guess an email address.
- Never write to more than 2 people at one company in 30 days.
- Never claim they know someone they did not name.
- Never invent experience; only their record and their words.
