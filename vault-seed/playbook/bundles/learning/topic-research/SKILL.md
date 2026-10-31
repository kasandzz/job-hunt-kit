---
name: topic-research
description: Look into a question on the web, read at least 4 sources and write a short brief that leads with the answer, with a source link for every claim. Triggers: "research this for me", "look into this for me", "investiga esto", "averigua esto", "paieškok apie tai", "išsiaiškink tai".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.

2. **Confirm the question in one line.** Rewrite what they asked as one clear question and show it in a question box: en-GB "So you want to know: <question>. Is that right?" es-MX "Entonces quieres saber: <question>. ¿Es eso?" Options: **Yes, that's it (Recommended)** / **Change it** / **tell me more** (es-MX **Sí, eso (Recomendado)** / **Cambiarla** / **cuéntame más**). If it is about where they live (prices, services, rules), include their country from the language profile.

3. **Search.** Use WebSearch with 2-3 different phrasings, in English and in their language when that helps. Prefer official, well-known or expert sources; avoid shops selling the thing being asked about.

4. **Read at least 4 sources.** Open each with WebFetch and read it. A source you did not open does not count. If fewer than 4 can be read, say so in the brief.

5. **Write the brief.** Use `playbook/templates/research.md` in the `research` folder from the language profile. File name `<yyyy-mm-dd>-<two-to-five-words>.md`, lowercase with hyphens, no accents. Fill `question:` and a one-line `summary:`.
   - "Short answer": 2-4 sentences that answer the question first, then the most important detail.
   - Every claim has a source link right after it, as `([source name](link))`.
   - Anything sources disagree on, or that you could not confirm, is marked "not sure" ("no es seguro") with what each side says.
   - "Sources": every source you read, as `- [Title](link)`.
   - "What to do next": 1-3 small, practical steps.
   - Health, money or legal questions: add one line that this is general information and to check with a professional before acting.

6. **Tell them** in 3 lines or fewer: the short answer, any "not sure" point, and where the brief is saved. Plain words, no source list in the chat unless they ask. Call the sources "the websites I read" ("las páginas que leí"), and the brief "a short note" ("una nota corta").

## Never
- Never state something without a source link, and never invent a source, title, number or link.
- Never present a guess as a fact; mark it "not sure".
- Never fill forms, sign up, buy or log in to anything while researching.
- Never use tech words from the language profile's "Avoid" list.
