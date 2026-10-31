---
name: video-summary
description: Summarise a YouTube or Vimeo video from its captions, in the user's language, with one action tied to their goals. Triggers: "summarise this video", "summarize this video", "resume este video", "resúmeme este video", "apibendrink šį vaizdo įrašą", "trumpai papasakok šį vaizdo įrašą".
---

## Steps
1. **Who.** Read `playbook/state/profile.json` and the language profile `playbook/profiles/language-<language>.md`. Speak only in that language and use its folder table. Never show a word from its "Avoid" list.

2. **Get the captions, never the video.** Run exactly this, with the link they gave you in double quotes:
   `powershell -NoProfile -ExecutionPolicy Bypass -File playbook/tools/get-subs.ps1 -Url "<url>"`
   This is the only allowed way to fetch captions. It prints the paths of the caption files it saved in `%TEMP%\pol-subs`, one per line.
   - Exit code 2 (link refused): say kindly, en-GB "That link didn't work. A link is the web address of the video. Open the video, click Share under it, then Copy, and paste it here." es-MX "Ese enlace no funcionó. El enlace es la dirección del video en internet. Abre el video, dale clic en Compartir abajo del video, luego en Copiar, y pégalo aquí." Do not try again with a changed link yourself.
   - Exit code 3 (the caption tool is missing) or any other failure twice: say kindly this one needs Kas and suggest "help me send this to Kas" ("manda esto a Kas"). Offer the title-only summary from step 7.
   - Exit 0 but no paths printed: there are no captions. Go to step 7.

3. **Pick one caption file.** Take the first printed path whose name has their language (`.es` for es-MX, `.en` for en-GB, including variants like `.en-GB` or `.es-419`). If none, take the first path printed.

4. **Clean it.** Read the .vtt. Drop the `WEBVTT` header, cue numbers, timestamp lines (`00:01:02.000 --> ...`), tags like `<c>` or `<00:00:01.000>`, and lines repeated straight after themselves (auto captions repeat a lot). For a long video read it in parts; never skip the second half.

5. **Title and channel.** Use WebFetch on the video page for the title, channel and length. If that fails, use the first words of the captions as a working title and leave `channel` empty.

6. **Write the note.** Use `playbook/templates/video.md` in the `videos` folder from the language profile. File name `<yyyy-mm-dd>-<two-to-five-words>.md`, lowercase with hyphens, no accents. Fill `url`, `channel`, `length` and a one-line `summary:`.
   - Write in the user's language whatever the video's language.
   - "Summary": 3-5 sentences, the main point first.
   - "Key points": 4-7 bullets, plain words.
   - "1 action": read their goal notes in the `goals` folder and `about-me.md` in the `home` folder, then give ONE small action from the video that fits a goal of theirs, naming the goal. If nothing fits, give one action that fits the video.
   Then tell them in 3 lines: the main point, the action, and where the note is saved.

7. **No captions.** Say plainly: "This video has no captions (the words written along the bottom), so I can't tell what's said in it." ("Este video no tiene subtítulos (las palabras escritas abajo), así que no puedo saber lo que dice."). Offer in a question box: en-GB "I can still tell you what the video is about from its title and the short text under it. Shall I?" es-MX "Igual te puedo decir de qué trata con su título y el textito que viene abajo. ¿Va?" Options: **Summarise from the title and description (Recommended)** / **Leave it** / **tell me more** (es-MX **Resumir con el título y la descripción (Recomendado)** / **Déjalo** / **cuéntame más**). If yes, use WebFetch on the page and write the note as in step 6, with this first line under "Summary": "From the title and description only, not the video itself." ("Solo del título y la descripción, no del video."). Keep it short and never guess what is said in the video.

## Never
- Never download the video or its sound, and never run the caption tool's program directly; only `get-subs.ps1` as shown in step 2.
- Never pass anything but the single link they gave you to `get-subs.ps1`.
- Never invent what the video says; everything comes from the captions or, clearly labelled, the page.
- Never delete the caption files or anything else.
- Never use tech words from the language profile's "Avoid" list (say "captions"/"subtítulos", not file types).
