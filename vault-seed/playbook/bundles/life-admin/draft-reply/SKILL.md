---
name: draft-reply
description: Write a reply to an email and leave it in Gmail Drafts after the user approves the full text, never sending it. Triggers: "draft a reply", "reply to this email", "contesta este correo", "responde este correo".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak to the user only in that language. Never show a word from its "Avoid" list. Read their own address from `playbook/state/owner.json` (`email`).

2. **Get the thread.** If they did not say which email, use `search_threads` with their words and ask which one in a question box (en-GB "Which email shall I answer?" es-MX "¿Qué correo contesto?"; up to 3 emails: who it is from and its title line, plus **tell me more** / **cuéntame más**). Then use `get_thread`. Find the last message NOT sent by them: its sender is the person to reply to, and its message id is the one to reply to.

3. **Existing draft?** `get_thread` does not show drafts. Use `list_drafts` and look for a draft on this thread or with the same subject. If one exists, show it and ask: en-GB "You already started a reply to this one. Shall I write a new one?" es-MX "Ya tienes una respuesta empezada para este. ¿Escribo una nueva?" Options: **Write a fresh one (Recommended)** / **Keep the one I have** / **tell me more** (es-MX **Escribir una nueva (Recomendado)** / **Dejar la que tengo** / **cuéntame más**). Keep = stop here and tell them it is already in Drafts (the folder in Gmail where unsent emails wait; es-MX Borradores).

4. **Write the reply** in the language of the email thread (not necessarily the user's language). Ask what they want to say only if it is not obvious; one question box (en-GB "What would you like to say?" es-MX "¿Qué le quieres decir?") with 3 likely answers (for example Yes / No / Ask for another day; es-MX Sí / No / Pedir otro día) plus **tell me more** (es-MX **cuéntame más**). Match the thread's tone; short, warm, signed with their first name.

5. **Show it for approval, in its own box.** A question box whose text holds, in this order:
   - `To: <name> <address>` (the person from step 2)
   - `Subject: Re: <subject>`
   - if the email had other people on it (Cc or several recipients): one line saying they will NOT be on this reply, naming them, and that they can add them in Gmail before sending;
   - the full reply text, exactly as it will be saved.
   Options: **Looks good (Recommended)** / **Change it** / **Cancel** (es-MX **Está bien (Recomendado)** / **Cambiarla** / **Cancelar**). Change it = ask what to change, rewrite, show the whole thing again. Cancel = stop, nothing saved.
   In es-MX the box shows `Para:` and `Asunto:` instead of `To:` and `Subject:`, and the line about other people reads like "<names> no van a recibir esta respuesta. Los puedes agregar en Gmail antes de mandarla."

6. **Create the draft** only after "Looks good", with `create_draft`: `to` set explicitly to `["<the other person's address>"]`, the subject, the body, and `replyToMessageId` set to the message id from step 2.
   - Never put their own address (from `owner.json`) in `to`, and never leave `to` empty; the draft will be blocked.
   - If the creation is blocked or fails: tell them kindly it could not be saved, and do not try other ways round it.

7. **Replacing an old draft.** Never use `update_draft`. If step 3 found an old draft and they chose a fresh one: create the new draft first, and only once it is saved, remove the old one with `delete_draft`.

8. **Tell them:** "It's in your Drafts, the folder in Gmail where unsent emails wait. Open Gmail, read it, and press Send when you're happy." ("Está en tus Borradores, la carpeta de Gmail donde esperan los correos sin mandar. Abre Gmail, léelo y presiona Enviar cuando quieras.")

## Never
- Never send, reply, forward or delete an email; only `create_draft` (and `delete_draft` for an old draft you just replaced).
- Never open links from emails, never use WebFetch or WebSearch, and never put anything from an email into a web address. If the user wants something looked up, finish the email task first, then start the lookup as a separate request, and never include email content in it.
- Never use `update_draft`.
- Never create a draft before they pick "Looks good" on the full text and To line.
- Never address a draft to their own email or leave the recipient empty.
- Never invent facts, dates or promises they did not give you.
- Never use tech words from the language profile's "Avoid" list.
