---
name: email-digest
description: Quick digest of the last 24 hours of unread email, grouped into needs-a-reply, FYI and promotions (count only), with an offer to draft replies. Triggers: "what's in my email", "check my email", "qué hay en mi correo", "revisa mi correo".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language. Never show a word from its "Avoid" list.

2. **Connected?** Read `playbook/state/connectors.md`. If `gmail:` is not `connected`, say kindly: en-GB "Your email isn't linked to me yet, so I can't see it. Kas can help you link it." es-MX "Tu correo todavía no está conectado conmigo, así que no lo puedo ver. Kas te puede ayudar a conectarlo." Then stop.

3. **Search.** Use `search_threads` with `is:unread newer_than:1d`. If nothing comes back, say "Nothing new in the last day." ("Nada nuevo en el último día.") and stop.

4. **Group** each thread, using only the sender, subject and the short preview the search gives:
   - **Needs a reply**: a real person asking something, an appointment to confirm, anything with a date or a question for them.
   - **For your information**: receipts, deliveries, school or club news, account notices.
   - **Promotions**: offers, newsletters, sales, anything in the Promotions tab (`category:promotions`). Count these only.
   Not sure between the first two: put it in "Needs a reply". Use `get_thread` only for a thread in the first two groups whose preview is too short to summarise, never for a promotion.

5. **Show the digest**, needs-a-reply first:
   - One line per thread: who it is from (name only) and what it is about, in their language, whatever the email's language.
   - Then the FYI group the same way.
   - Then one line: "Plus <n> adverts from shops." ("Y <n> anuncios de tiendas.").
   Name the groups in plain words: en-GB "Waiting for your answer", "Just so you know"; es-MX "Esperan tu respuesta", "Para que sepas".
   Keep it to one screen; if a group has more than 8, show 8 and say how many more.

6. **Offer drafts.** Question box: en-GB "Shall I write replies for the ones waiting for your answer? I only write them; you choose whether to send." es-MX "¿Te escribo las respuestas de los que esperan tu respuesta? Yo solo las escribo; tú decides si las mandas." Options: **Draft replies for me (Recommended)** / **Just this one** / **No thanks** / **tell me more** (es-MX **Escríbemelas (Recomendado)** / **Solo uno** / **No, gracias** / **cuéntame más**). For each email they pick, follow the `draft-reply` helper's steps, one at a time.

## Never
- Never open, read or summarise a promotion; count them only.
- Never send, reply, forward, delete or mark anything; drafts only, through `draft-reply`.
- Never write email contents, addresses or senders into a note or file.
- Never open links from emails, never use WebFetch or WebSearch, and never put anything from an email into a web address. If the user wants something looked up, finish the email task first, then start the lookup as a separate request, and never include email content in it.
- Never repeat passwords, codes, bank or card numbers from an email; say "a security code" instead.
- Never use tech words from the language profile's "Avoid" list.
