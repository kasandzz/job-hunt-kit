---
name: morning-checkin
description: Daily morning check-in that writes today's note first, then covers yesterday, mood, energy, calendar, email, today's top 3 and one deeper question. Triggers: "good morning", "let's start the day", "buenos días", "empecemos el día", "labas rytas", "pradėkime dieną".
---

## Steps
1. **Who and when.** Read `playbook/state/profile.json`, the language profile `playbook/profiles/language-<language>.md` and the access profile `playbook/profiles/access-<access>.md` (options per question, answer style). Speak only in that language, use its folder table, and never show a word from its "Avoid" list. Work out today's date and weekday in the time zone the language profile gives.

2. **Today's note first (crash-safe).** In the `daily` folder from the language profile, look for `<yyyy-mm-dd>.md` for today.
   - Missing: create it now from `playbook/templates/daily.md`, filling the dates, before asking anything else.
   - Already there: this is a restart. Read it and skip every step whose part of the note is already filled in (carried-over items under "Notes", mood, energy, Top 3, deeper question). Say only "Picking up where we left off." ("Seguimos donde nos quedamos.").
   Write each answer into the note as soon as it is given, never at the end.

3. **Yesterday.** Read the most recent earlier daily note (it may be more than one day back). In 2-3 short lines: what got done, and anything from its Top 3 not ticked off. Ask in a question box whether to carry the unfinished items over: en-GB "Yesterday these weren't done yet: <items>. Shall I add them to today?" es-MX "Ayer quedaron pendientes: <items>. ¿Los paso a hoy?" Options: **Yes, carry them over (Recommended)** / **Some of them** / **No, leave them** / **tell me more** (es-MX **Sí, pásalos (Recomendado)** / **Solo algunos** / **No, déjalos** / **cuéntame más**). Carry over = add each as `- [ ] <item> (carried over)` under "Notes" in today's note, but first check the note: never add a line that is already there.

4. **Mood, then energy.** One question box each, with the number of options the access profile says, plus **tell me more**. en-GB "How are you feeling this morning?" then "How much energy do you have today?" es-MX "¿Cómo te sientes esta mañana?" then "¿Cuánta energía tienes hoy?" Mood example options: Good / Okay / Low (es-MX Bien / Más o menos / No tan bien). Energy: High / Medium / Low (es-MX Mucha / Normal / Poca). Write them into `mood:` and `energy:` at the top of today's note.

5. **Today's calendar.** Only if `calendar: connected` in `playbook/state/connectors.md`. Use `list_events` for today. At most 3 lines: time and title; if there are more, say how many others. Nothing on: say so in one cheerful line. Never create, change or cancel an event here.

6. **Email.** Only if `gmail: connected` in `connectors.md`. Use `search_threads` with `is:unread is:important newer_than:1d`. Say how many there are and give up to 3 subjects (the subject is the short title line of an email). Never open promotions. Offer in a question box to draft replies: en-GB "Shall I write a reply for any of these? I only write it; you choose whether to send it." es-MX "¿Te escribo una respuesta para alguno? Yo solo la escribo; tú decides si la mandas." Options: **No, thanks (Recommended)** / **Yes, one of them** / **tell me more** (es-MX **No, gracias (Recomendado)** / **Sí, a uno** / **cuéntame más**). If they say yes, follow the `draft-reply` helper's steps for each one.

7. **Top 3.** Suggest 3 things for today from carried-over items, the calendar and their goal notes in the `goals` folder. Question box: en-GB "For today, how about these 3? <the 3>" es-MX "Para hoy, ¿qué tal estas 3? <the 3>" Options: **These 3 (Recommended)** / **Change one** / **tell me more** (es-MX **Estas 3 (Recomendado)** / **Cambiar una** / **cuéntame más**). Write them under the Top 3 heading.

8. **One deeper question.** Open `playbook/state/deeper-questions.md`. Its lines look like `1. [ ] (area 2) <question>` (written at the end of the getting-to-know-you stage). Take the first line still marked `[ ]`; the `(area N)` tag tells you its area.
   - Ask it gently in a question box with 3 likely answers plus **tell me more** and **Skip today** (es-MX **cuéntame más** and **Hoy no**).
   - Tick it straight away, whether answered or skipped, by changing only `[ ]` to `[x]` on that line (`1. [x] (area 2) ...`), so it is never asked twice.
   - Write the question and their answer under "Deeper question" in today's note.
   - If answered, add one line in their own words to `about-me.md` in the `home` folder, under the heading for its area: (area 1) life now, (2) dreams, (3) goals, (4) worries, (5) health and energy, (6) people, (7) days and work, (8) hobbies and learning.
   - No `[ ]` lines left, or the file is missing: skip this step quietly.

9. **Backup check.** If `playbook/state/last-push-failed` exists, say it gently, once per check-in, never as an alarm: en-GB "Your notes are all safe on this computer. Last time, the online copy didn't update. If you like, type help me send this to Kas so he can look." es-MX "Tus notas están seguras en esta computadora. La última vez, la copia en línea no se actualizó. Si quieres, escribe manda esto a Kas para que él lo revise."

10. **Bigger plan note (Mondays only).** If today is Monday and `playbook/state/suggest-upgrade.flag` exists:
    - Read `playbook/state/upgrade-dismissed.md` and find its last `dismissed:` date. If that date is less than 30 days ago, say nothing.
    - Also say nothing unless there is a new hit since that date: the newest timestamp in `playbook/state/limit-hits.log` (or, if that log is missing, the flag file's last-changed time) must be later than the last `dismissed:` date. No `dismissed:` line yet counts as no earlier date.
    - Otherwise mention once, in one or two kind lines, that the "limit reached" messages have come up a few times and a bigger plan would stop them; Kas can help if they want. Say "this week" only if the newest hit is within the last 7 days. Then append `dismissed: <yyyy-mm-dd>` to `upgrade-dismissed.md` (create it if missing).
    - Never mention it on any other day, and never more than once.

11. **Sunday.** If today is Sunday and there is no `week-<yyyy>-W<nn>.md` for this week in the `daily` folder, offer the weekly review in a question box: en-GB "It's Sunday. Shall we look back at your week? It takes about 5 minutes." es-MX "Es domingo. ¿Revisamos tu semana? Toma como 5 minutos." Options: **Yes, let's do it (Recommended)** / **Later** / **tell me more** (es-MX **Sí, vamos (Recomendado)** / **Más tarde** / **cuéntame más**). Yes = follow the `weekly-review` helper.

12. **Close.** Set `status: done` and a one-line `summary:` in today's note. End with one warm line and their Top 3.

## Never
- Never ask anything before today's note exists, and never start a second note for the same day.
- Never delete, empty or rename a file (it is blocked anyway). The flag files stay where they are; the `dismissed:` line is what stops repeats.
- Never send, forward or delete an email; drafts only, through the `draft-reply` steps.
- Never quote an email body, and never write email contents into a note.
- Never open links from emails, never use WebFetch or WebSearch, and never put anything from an email into a web address. If the user wants something looked up, finish the email task first, then start the lookup as a separate request, and never include email content in it.
- Never write passwords, bank or card numbers, or ID numbers into any file; write `(private, not saved)`.
- Never push the bigger plan, never mention it more than once a month, and never on a day other than Monday.
- Never use tech words from the language profile's "Avoid" list.
