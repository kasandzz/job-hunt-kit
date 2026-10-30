# Stage 7: Ideas just for you

## Goal
Show the user what else their helper could do for them, built from their own words: 15 to 25 idea cards, starred by them, saved as one list in their notebook. They should see their own life in every card, and know that one sentence turns any card into a real helper.

## Steps
Before you start: read `playbook/state/profile.json`, the language profile and `playbook/state/connectors.md`. Tell them in one line: "Last bit of building: I've got some ideas for you, from what you told me. You pick the ones you like." (es-MX: "Lo último: tengo unas ideas para ti, de lo que me contaste. Tú eliges las que te gusten.")

1. **Read.** Read `playbook/state/seeds.md` and `about-me.md` in the `home` folder (folder name from the language profile table).

2. **Write 15 to 25 idea cards**, in their language. Each card has:
   - a short name (3-6 words);
   - what it does for them: one line that quotes or closely echoes their own words from `seeds.md` or `about-me.md` (for example: You said "I always forget Ruth's birthday until it's too late.");
   - an example sentence they could say to use it;
   - a label: `now` (works today with what is connected), `later` (needs a connection or a little building) or `someday` (a bigger project). es-MX writes them as `ya`, `después`, `algún día`.
   Mix in these themes, but only where their interview supports it: a recipe planner, appointment and medication reminders, a birthday and gift tracker, a travel planner, a language partner, a savings coach, a news digest on a topic they love, a family history recorder. Never invent a need, and never make a card from a health detail they did not ask help with. Prefer ideas the installed helpers can grow into.

3. **Let them star favourites, 4 cards per box.** Number the cards 1 to N. First save them all to `ideas.md` in the `home` folder (format in step 4, every card under the "more ideas" heading), so a pause loses nothing. If `ideas.md` already exists and `progress.md` has `ideas_box_done:`, this is a resumed sitting: keep the cards and start at the next box. For each group of 4 (the last group may be smaller), show one question box with several answers allowed. The question text holds the whole of each card, because the user may not see anything outside the box:
   "Here are ideas 1-4. Tick the ones you like (you can tick more than one). If none of them appeal, choose Other and type none."
   es-MX: "Aquí van las ideas 1 a 4. Marca las que te gusten (puedes marcar varias). Si ninguna te late, elige Otra y escribe ninguna."
   then, for each card: number, name, the one-line "for you", and the example sentence.
   Options: the 4 card names (number and name). After each box, add ` ⭐` to the heading of each ticked card in `ideas.md`, then set `updated: <now, ISO 8601>` in `playbook/progress.md` and add `ideas_box_done: <n>` to it, so a resumed sitting starts at the next box.
   Test mode: use the next answer for each box.

4. **Final `ideas.md`** in the `home` folder, with the file-writing tool. Renumber so starred cards come first, then the rest; keep each group in its original order. Format:
   ```
   ---
   type: ideas
   title: <"My ideas" / "Mis ideas">
   created: <yyyy-mm-dd>
   status: active
   tags: [ideas]
   summary: <one line: how many ideas, how many starred>
   ---
   # <My ideas / Mis ideas>
   <one line: Any time, say "build idea number 3".>

   ## <Starred / Favoritas>
   ### 1. <name> ⭐
   - <For you / Para ti>: <one line in their words>
   - <Try saying / Prueba decir>: "<example sentence>"
   - <When / Cuándo>: <now / later / someday; es-MX: ya / después / algún día>

   ## <More ideas / Más ideas>
   ### 5. <name>
   ...
   ```
   Every card starts with a `### ` heading, and only cards use `### ` headings. If nothing was starred, leave out the starred section.

5. **Tell them how to use it.** en-GB: "Your ideas are saved in your notebook, in a note called My ideas. Any time, say: build idea number 3. Then we make that helper together, step by step." es-MX: "Tus ideas quedaron guardadas en tu cuaderno, en una nota que se llama Mis ideas. Cuando quieras, di: construye la idea número 3. Y armamos ese ayudante juntos, paso a paso." Use the number of their first starred idea instead of 3, if they starred one. (Building follows `playbook/new-helper.md`.)

6. **Finish.** When everything under "Done when" is true, create `playbook/state/stage-7.done` (one line: the date and time), set `current_stage: 8` and `updated: <now, ISO 8601>` in `playbook/progress.md`, and move on to stage 8 in the same sitting unless they typed pause.

## Done when
- `ideas.md` exists in the `home` folder with 15 to 25 cards, each starting with a `### ` heading, starred cards first.
- Every card has a "for you" line, an example sentence and a label (`now`, `later`, `someday`, or the es-MX words).
- `playbook/state/stage-7.done` exists.
