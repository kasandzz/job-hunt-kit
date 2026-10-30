---
name: calendar-lookahead
description: Look at the next 7 days of the calendar, flag clashes and early starts, and remind about birthdays from people notes. Triggers: "what's on this week", "what's on my calendar", "qué tengo esta semana", "qué tengo en mi calendario".
---

## Steps
1. **Who and when.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table and time zone. Never show a word from its "Avoid" list.

2. **Connected?** Read `playbook/state/connectors.md`. If `calendar:` is not `connected`, say kindly: en-GB "Your diary isn't linked to me yet, so I can't see it. Kas can help you link it." es-MX "Tu agenda todavía no está conectada conmigo, así que no la puedo ver. Kas te puede ayudar a conectarla." Then skip to step 5 (birthdays still work).

3. **The next 7 days.** Use `list_events` from now to 7 days ahead. Show one short block per day that has something on: the day in words ("Tuesday 13 October" / "martes 13 de octubre"), then `<time> <title>` lines. Days with nothing: leave them out, then add one line naming the free days.

4. **Flag what matters**, each as one line under its day:
   - **Clash:** two events that overlap in time.
   - **Early start:** anything before 8:00.
   - **Busy day:** 4 or more events.

5. **Birthdays.** Read the people notes in the `people` folder. For any `birthday:` that falls in the next 7 days (month and day only), add "Birthday: <name> on <day>". Offer a reminder or a gift idea in a question box: en-GB "<name>'s birthday is on <day>. Would you like a reminder, or to note a gift idea?" es-MX "El cumpleaños de <name> es el <day>. ¿Quieres un recordatorio o anotar una idea de regalo?" Options: **Remind me on the day (Recommended)** / **Note a gift idea** / **No thanks** / **tell me more** (es-MX **Recuérdamelo ese día (Recomendado)** / **Anotar idea de regalo** / **No, gracias** / **cuéntame más**). Remind me = add `- [ ] <name>'s birthday` under "Notes" in that day's daily note if it exists, or in the `inbox` folder. Gift idea = add `- Gift idea: <idea>` under "Things to remember" in their person note.

6. **Adding an event (only if they ask).** Never add one on your own.
   - First show every detail in a question box: title, day, start and end time, place. en-GB "I'll put this in your diary: <details>. OK?" es-MX "Voy a poner esto en tu agenda: <details>. ¿Va?" Options: **Add it (Recommended)** / **Change something** / **Cancel** (es-MX **Agrégalo (Recomendado)** / **Cambiar algo** / **Cancelar**).
   - Only after "Add it" ("Agrégalo"), create it. Never add guests: Google emails every guest an invitation.
   - es-MX: write the times with the offset, like `2026-10-13T09:00:00-06:00`, and leave out the time zone field.
   - en-GB: use the time zone in the language profile.
   - If it is blocked or fails, say kindly it could not be added and suggest they add it themselves in Google Calendar (their diary on the Google website or the phone app).

7. **Close** with one line: the busiest day, or "a calm week" if it is.

## Never
- Never change, move, cancel or delete an existing event, and never reply to invitations; suggest they do it in Google Calendar.
- Never create an event without showing the details first and getting "Add it".
- Never share or write event details into notes, except the birthday reminder line.
- Never use tech words from the language profile's "Avoid" list.
