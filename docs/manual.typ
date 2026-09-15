// The real manual --- progressive, one function (and every one of its
// options) at a time. Imports NOTHING from checkitoff and runs no package
// code: every result shown below is a PNG produced by actually compiling
// a real file under docs/manual-snippets/, not a simulation. Regenerate
// everything with:
//   bash docs/manual-snippets/compile.sh

#set document(title: "checkitoff — manual")
#set page(paper: "a4", margin: (x: 2.2cm, y: 2cm))
#set text(size: 10.5pt, font: "Libertinus Serif")
#set heading(numbering: "1.1.")
#set par(justify: true)
#show raw: set text(font: "Linux Libertine Mono", size: 0.85em)

#let code(src) = block(
  fill: luma(247), stroke: 0.5pt + luma(210), inset: 10pt, radius: 3pt, width: 100%,
  raw(src, block: true, lang: if src.starts-with("typst") { "sh" } else { "typ" }),
)

#let code-of(path) = code(read(path))

#let shot(path, caption: none, width: 100%) = block(width: width)[
  #block(stroke: 0.5pt + luma(210), inset: 4pt, radius: 3pt, width: 100%, image(path, width: 100%))
  #if caption != none [#text(size: 0.78em, fill: luma(120), style: "italic")[#caption]]
]

#align(center)[
  #v(0.5cm)
  #text(size: 1.8em, weight: "bold")[checkitoff]
  #v(0.2em)
  #text(size: 1.1em, style: "italic")[User manual]
  #v(0.8cm)
]

#outline(indent: auto)
#pagebreak()

= What checkitoff is for

Reporting guidelines (CONSORT for randomised trials, PRISMA for systematic reviews, SPIRIT for trial protocols, STARD, STROBE...) ask an author to prove that a manuscript reports a fixed list of items --- and, for most journals, to submit a completed grid citing the exact page where each one appears. Written by hand, that grid is done once, then quietly goes stale the first time a paragraph moves.

Checkitoff automates it. Mark each item where it actually appears in your manuscript --- `#check("6a")[...]` around the sentence describing your primary outcome, say --- and one compile produces both:

- *`manuscript.pdf`* --- exactly what you're submitting, with no visible trace of any `check()` call;
- *`checklist.pdf`* --- the official grid, filled in, citing the real page number each item landed on *in that same compile*. Move a paragraph, recompile, and the numbers are simply right again.

This only works because both documents come out of a single Typst compile that can see its own final layout. Checkitoff itself doesn't implement that part: it's built on `contexture`, a small shared package that does the actual multi-document plumbing and is installed alongside it (see the next chapter). You don't need to learn `contexture` to use checkitoff --- everything you need is shown here, one step at a time. The closing chapter, "Checkitoff in the contexture ecosystem," explains what `contexture` actually does and introduces `@preview/palimpsest`, a sibling package for tracked manuscript revisions and reviewer response letters, for anyone who wants the bigger picture or needs to combine the two.

= Installation and compiling

#code(
  "#import \"@preview/checkitoff:0.1.0\": *\n" +
  "#import \"@preview/contexture:0.1.0\": bundle"
)

A manuscript plus its completed checklist compiles with one command:

#code("typst compile --features bundle --format bundle main.typ")

This produces `manuscript.pdf` and `checklist.pdf` from the same compile. A second, optional compile is useful while drafting:

#code(
  "typst compile --features bundle --format bundle --input preview=true main.typ"
)

This produces `manuscript-preview.pdf` only (no `checklist.pdf` in this compile --- see #link(<sec-pilot>)[why, below]) with every `check()`'d span lightly highlighted and tagged with its item id, so you can see at a glance what's covered so far and where. Nothing about it ever reaches the real submission.

Every example in this manual is a single, self-contained file, compiled directly --- the simplest way to show what each function does on its own. `check()` and `na()` even work in a plain `typst compile`, with no bundle at all: that's the form used for the very next example. A real, multi-file project instead wires its manuscript and its checklist together explicitly; that pattern is covered once you've seen the pieces it's built from, in #link(<sec-pilot>)[Wiring a real project].

= Your first checklist <sec-quickstart>

The smallest complete example: a four-item made-up checklist (a real project would pass `checklists.consort` or another built-in grid instead --- see #link(<sec-checklists>)[Built-in checklists] --- but a tiny one keeps the whole grid on one page here), a short manuscript, and two `check()` calls plus one `na()`.

#code-of("manual-snippets/bundle-basics.typ")

A few things to notice in that file, top to bottom:

+ `tiny` is nothing but a dictionary: a `name`, a `full-name`, and a list of `items`, each with a `section`, an optional `topic`/`group`, an `id`, and a `description`. Nothing here is specific to checkitoff's internals --- it's the same shape every built-in checklist uses, and the same shape a house checklist of your own would use.
+ `#show: contexture.bundle.with(...)` is the one line of setup a real project needs: it tells Typst which checklist is active (`checklist(checklist: tiny)`) and applies a page template to the manuscript. Everything after it is your manuscript, written exactly as you'd write it without checkitoff at all.
+ `#check("1a")[...]` wraps a passage of the manuscript and records "this is where item 1a is answered." `#na("14", reason: [...])` instead declares, in one line, that item 14 doesn't apply here --- with a justification, not a silent omission.

Compiled plain, `manuscript.pdf` shows nothing but ordinary prose --- no box, no id, no visible trace of `check()` at all:

#shot("manual-snippets/bundle-basics/manuscript-plain.png")

Compiled again with `--input preview=true` --- a drafting view only, never part of the real submission --- each checked span is lightly highlighted with its item id superscripted, so you can see coverage at a glance while writing (`checklist.pdf` isn't produced in this compile at all --- see #link(<sec-pilot>)[why below]):

#shot("manual-snippets/bundle-basics/manuscript-preview.png")

And here is `checklist.pdf`, from the first, plain compile --- the actual deliverable:

#shot("manual-snippets/bundle-basics/checklist-plain.png")

Worth noticing in that grid: "Randomisation" (item 10/11's shared `group`) renders as its own band nested inside the "Methods" section band --- an item's `group`, when it has one, always gets this treatment. Item 14 shows `N/A` in the Page column, with its justification printed verbatim underneath, in the "Not applicable" block --- both come directly from the single `na("14", reason: [...])` call above, with no `check()` anywhere for that id. If an item had been left neither `check()`'d nor `na()`'d, its Page cell would instead show a small warning marker --- covered in full in #link(<sec-diagnostics>)[Reading the grid], once the individual marking functions have been introduced properly.

== Recommended workflow

The example above is the whole mechanism; a real manuscript just repeats the same two calls, `check()` and `na()`, at every relevant spot. In practice:

+ Pick a checklist --- one of the built-in ones (#link(<sec-checklists>)[below]), or your own dictionary of the same shape.
+ Write the manuscript as usual, wrapping each passage that answers an item in `check(id)[...]`, and grouping every genuinely inapplicable item under `na(id, reason: [...])`.
+ While drafting, compile with `--input preview=true` from time to time --- a quick visual check of what's covered and what isn't yet, with no effect on the real manuscript.
+ Once the draft feels complete, compile normally and read `checklist.pdf`. Its Diagnostics block (#link(<sec-diagnostics>)[below]) lists anything unresolved: an item never covered, a `check()` with nothing in it, an id that doesn't match any item, or a genuine contradiction.
+ Fix each one --- add the missing `check()`, or an `na()` with a real reason --- and recompile.
+ Before submission, compile once with `strict: true` (#link(<sec-strict>)[below]): every remaining diagnostic becomes a hard compile error instead of a soft marker, a clean pass-fail gate.
+ Submit `manuscript.pdf` and `checklist.pdf` together --- they came from the same compile, so the page numbers in one are guaranteed to match the other.

= Marking items: `check` and `na`

/ `check(id, body)`: anchors `body` to item `id` of whichever checklist is active for this compile, and renders `body` exactly as written. Zero visual footprint in the plain compile --- safe inside any journal template's flow. Under `--input preview=true`, `body` gets a light highlight with the item id superscripted, purely as a drafting aid.
/ `na(id, reason: none)`: declares item `id` not applicable to this manuscript, with an optional justification. Renders nothing at the call site --- it's typically grouped in one dedicated block rather than scattered through the text, as in the example above.

A minimal, standalone example --- no bundle involved, just `check()` in a plain file:

#code-of("manual-snippets/marks-check-basics.typ")

Compiled once, plain:

#shot("manual-snippets/marks-check-basics/result-plain.png")

Once more with `--input preview=true`:

#shot("manual-snippets/marks-check-basics/result-preview.png")

`check()` doesn't need to know which checklist is active, or even that one exists --- it just anchors `body` under `id`; whether that id means anything is only decided later, when the grid is built. That's why this file compiles and renders correctly entirely on its own, with no `#show: bundle.with(...)` anywhere. It's also why an id that turns out not to match any item is a diagnostic caught later, in the grid, rather than an error here.

An item can legitimately be checked more than once --- a method described once and its rationale discussed elsewhere, say --- in which case the grid lists every page it was found on. The one deliberate exception is a single passage that straddles a page break: see #link(<sec-page-break>)[The page-break idiom] for the recommended way to get a correct, two-page citation for that case specifically.

`na()` is the explicit counterpart to `check()`: some items genuinely don't apply to a given manuscript (a trial with no serious adverse events has nothing to say for a "Harms" item, for instance). Declaring it, with a reason, turns "item never mentioned" from an oversight worth flagging into a documented, deliberate choice.

== The point-marker form: `check(id)` alone

`check(id, body)` renders `body` --- and that's the right call almost every time, since most items simply live at their own spot in the manuscript. Occasionally, though, the passage an item covers is already being rendered by something else --- most commonly another package's own marking call, when what a reviewer asked you to change happens to *be* your answer to a checklist item. Calling `check(id, body)` there too would print the same text a second time, since it always renders `body` itself.

For exactly that case, `check(id)` --- one argument, no body --- only ever registers the item's location; it never renders anything, ever. `body` must already be displayed by something else.

#code-of("manual-snippets/marks-check-point-marker.typ")

Compiled once, plain --- the sentence appears exactly once, exactly as written:

#shot("manual-snippets/marks-check-point-marker/manuscript-plain.png")

Once more with `--input preview=true` --- a small superscripted id, but no highlight box: there's no body here to wrap one around, but the id is still shown as a drafting aid:

#shot("manual-snippets/marks-check-point-marker/manuscript-preview.png")

The item still resolves correctly in `checklist.pdf`, exactly as if it had been written `check(id, body)`. The only function that notices the difference is `excerpt-of` (#link(<sec-excerpt>)[below]): with no body to quote, an occurrence marked this way simply contributes no excerpt, which is the honest answer, not an error. The "blank content" diagnostic never fires on it either --- a missing body here is the deliberate shape of this form, not the mistake it would be for `check(id)[]`.

The most common reason to reach for this form --- combining checkitoff with a package that already renders the text, such as `@preview/palimpsest`'s tracked-changes marks --- is covered in full in the closing chapter, #link(<sec-ecosystem>)[Checkitoff in the contexture ecosystem].

= Reading the grid <sec-diagnostics>

`render-checklist(checklist:, title: auto)` is the function that draws the grid you already saw in #link(<sec-quickstart>)[Your first checklist]: every official item, grouped by section (and, when the checklist has one, by a mid-level group inside a section), each item's resolved page number(s), and a Diagnostics block listing anything that doesn't add up. In an ordinary project you never call it directly --- the `checklist(...)` satellite (#link(<sec-pilot>)[below]) calls it for you --- but it's exported on its own too, in case a project ever needs the grid outside the usual two-document setup.

A checklist is plain data, as already seen: `name`, `full-name`, `items`, plus optional `headers`, `style`, and `citation` fields covered later in this manual. `checklist:` never defaults to anything, even though CONSORT ships built in --- an explicit choice costs nothing and avoids a silent, surprising default once a project is juggling more than one grid.

== Diagnostics

Five situations are flagged, always in the same way, so `strict:` mode (#link(<sec-strict>)[below]) catches every one of them consistently:

- an item never `check()`'d or `na()`'d at all --- *not covered*;
- a `check()` call whose content is blank --- most often a copy-paste slip, where the id was moved but the text wasn't filled in;
- an id used by `check()`/`na()` that matches no item in the active checklist --- typically a typo, or a leftover from switching checklists;
- the same id both `check()`'d and `na()`'d --- a real contradiction: an item can't be simultaneously reported somewhere and declared not applicable;
- the same id `na()`'d more than once.

The first three (not covered / blank / unknown id) show up right in the Page column, as a #text(fill: red.darken(20%), weight: "bold")[⚠] marker; every diagnostic's full sentence, including the two that have no single cell of their own (unknown id, duplicate `na()`), is listed underneath the table, in a dedicated Diagnostics block.

#code-of("manual-snippets/bundle-diagnostics.typ")

#shot("manual-snippets/bundle-diagnostics/checklist-plain.png")

This same example also shows what happens when consecutive items share one `topic` (t6/t7, both "Topic 4", under the "Sub-group demo" group): the Topic cell spans both rows instead of repeating.

== Strict mode <sec-strict>

By default, every diagnostic above is a soft, visible marker --- easy to spot while drafting, but it won't fail a build on its own. `strict: true`, passed to `contexture.bundle(...)` (not to `checklist(...)` --- strictness is a property of the whole compile, so it covers any other `contexture`-based package sharing it too), turns every one of them into a hard compile error instead:

#code(
  "#show: contexture.bundle.with(\n" +
  "  strict: true,\n" +
  "  documents: (checklist(checklist: my-checklist),),\n" +
  ")\n\n" +
  "= Manuscript\n\n" +
  "// No check(\"s1\") anywhere below --- this manuscript now\n" +
  "// FAILS TO COMPILE under strict: true, with a real compile\n" +
  "// error naming the uncovered item, instead of a soft marker\n" +
  "// sitting quietly in checklist.pdf.\n"
)

The positive case --- everything covered, `strict: true` compiles cleanly, with no diagnostic anywhere:

#code(
  "#show: contexture.bundle.with(\n" +
  "  strict: true,\n" +
  "  documents: (checklist(checklist: my-checklist),),\n" +
  ")\n\n" +
  "= Manuscript\n\n" +
  "#check(\"s1\")[This item is covered here.]\n" +
  "#na(\"s2\", reason: [Not applicable to this manuscript, with a\n" +
  "  proper justification.])\n"
)

A real project typically reserves `strict: true` for a CI compile or a final pre-submission check --- a hard gate --- while drafting locally without it, so an incomplete manuscript still produces a readable `checklist.pdf` with markers instead of refusing to build at all.

= Quoting the real wording: `excerpt-of` <sec-excerpt>

`excerpt-of(id, quotes: false, show-page: false, on-empty: none)` re-emits the exact content `check()` anchored to `id` --- one block per occurrence, so an item checked in two places yields two excerpts. It isn't part of the official grid, which only ever has a page-number column; it's for a supplementary appendix some journals or protocols additionally want, with the exact wording quoted next to each item, or for an internal compliance review.

#code-of("manual-snippets/bundle-excerpt.typ")

#shot("manual-snippets/bundle-excerpt/manuscript-plain.png")

`quotes: true` wraps a textual excerpt in real quotation marks, and silently declines on anything that isn't text --- a figure, a table, a block equation. `on-empty` (nothing, by default) is deliberately *not* a diagnostic the way an uncovered item is in the grid: this function can be called from inside the manuscript itself, where nothing should ever render a warning box in the real, submitted deliverable --- an uncovered item is already flagged exactly once, safely, in `checklist.pdf`.

= The page-break idiom <sec-page-break>

Checkitoff doesn't try to detect a passage that straddles a page break automatically --- there's no reliable way to tell "one logical passage split across pages" apart from "two genuinely separate mentions of the same item." The recommended idiom instead: call `check()` a second time, with the *same* id, right after the break.

#code-of("manual-snippets/bundle-page-break-idiom.typ")

The grid reports both pages, not a merged range and not just the first:

#shot("manual-snippets/bundle-page-break-idiom/checklist-plain-2.png")

Two genuinely separate mentions of the same item, landing on the same page, collapse to one page number instead --- the same rule, the other direction.

= Styling the grid: `set-style`

Every visual knob the grid and `check()`'s preview highlighting use goes through one shared mechanism, resolved in three layers, each overriding only what the previous layer left unset:

+ checkitoff's own package default --- generic and checklist-agnostic (portrait A4, no color, "use whatever the ambient template already set");
+ the active checklist's own `style:` field, if it has one --- CONSORT's real landscape A4 layout and column widths, taken from its official source document, is exactly this layer;
+ whatever you explicitly ask for via `set-style(...)`.

`set-style(...)` takes every knob as a keyword, `auto` by default ("don't touch this one"); repeated calls merge rather than reset:

#code(
  "#set-style(\n" +
  "  preview-color: auto,       // check()'s preview-mode highlight color\n" +
  "  show-id: auto,              // superscript the id in preview mode?\n" +
  "  paper: auto,                // grid page size, e.g. \"a4\", \"us-letter\"\n" +
  "  landscape: auto,            // grid page orientation\n" +
  "  columns: auto,              // 4 column widths, e.g. (18%, 7%, 1fr, 10%)\n" +
  "  font: auto,                 // grid text font\n" +
  "  text-size: auto,            // grid text size\n" +
  "  header-fill: auto,          // header row background\n" +
  "  header-text-color: auto,\n" +
  "  section-fill: auto,         // section band background\n" +
  "  section-text-color: auto,\n" +
  "  group-fill: auto,           // mid-level group band background\n" +
  "  group-text-color: auto,\n" +
  ")"
)

An override on a checklist with no `style:` of its own:

#code-of("manual-snippets/style-checklist-override.typ")

#shot("manual-snippets/style-checklist-override/checklist-plain.png")

`preview-color`/`show-id` also apply to `check()`'s own preview-mode highlight, independently of any checklist --- `check()` doesn't know which checklist is active, by design:

#code-of("manual-snippets/style-preview.typ")

#shot("manual-snippets/style-preview/result-preview.png")

These values always win, over both checkitoff's package default and the active checklist's own `style:` --- your explicit ask, for the manuscript you're compiling right now, is the most specific signal available. A checklist that ships its own faithful `style:` (CONSORT, PRISMA, ...) keeps looking like its real source document by default; `set-style(...)` is for the cases where that's not what you want --- matching a specific journal's house style, or simply personal preference.

= Wiring a real project <sec-pilot>

Every example so far is one file, compiled directly. A real project instead usually keeps the manuscript's prose in its own file and wires everything together from a small `main.typ`:

#code(
  "#show: contexture.bundle.with(\n" +
  "  template: my-manuscript-template,\n" +
  "  documents: (\n" +
  "    checklist(checklist: checklists.consort),\n" +
  "    // ... any other contexture-based package's satellite here too\n" +
  "  ),\n" +
  ")\n\n" +
  "#include \"manuscript.typ\""
)

`checklist(checklist:, grid-template: auto)` is what describes the checklist for `contexture.bundle` to build. `checklist:` has no default, for the same reason as `render-checklist`'s own `checklist:` above. `grid-template:` (`auto` = leave it alone) is applied to the grid separately from the manuscript's own `template:` --- most journals want CONSORT's own official table layout on the checklist page, not the manuscript's own house style.

*Restricting a compile to fewer documents.* `--input only=<comma-separated names>` restricts a single compile to just the manuscript plus the named documents --- `--input only=` with nothing after it produces the manuscript alone, with no checklist at all. Handy for a fast preview while drafting a long manuscript, where rebuilding the grid every time is unwanted overhead.

*Why doesn't `--input preview=true` produce a `checklist.pdf`?* `check()`'s preview highlighting adds a small box around each checked span, which can shift where a page breaks. A grid built from that layout could then report page numbers that don't match the manuscript actually being submitted --- worse than not producing one at all. `checklist.pdf` is only ever built from the one, real, plain compile.

*Does the checklist compile when the manuscript doesn't?* No. The manuscript and the checklist are two documents produced by the very same Typst compile, so a hard error anywhere in the manuscript aborts the whole compile, `checklist.pdf` included. A `check()`/`na()` diagnostic never does this on its own --- that's exactly what non-strict mode is for --- only a genuine error in the manuscript itself (an undefined function, a malformed table, ...) does.

= Built-in checklists <sec-checklists>

#table(
  columns: (auto, auto, auto, 1fr),
  align: (left, left, center, left),
  stroke: 0.5pt + gray,
  table.header[*`checklists.` key*][*Guideline*][*Items*][*Notes*],
  [`consort`], [CONSORT 2025 (randomised trials)], [42], [Landscape A4; one mid-level group, "Randomisation" (17a--21d).],
  [`prisma`], [PRISMA 2020 (systematic reviews)], [42], [Landscape US Letter; no mid-level groups.],
  [`spirit`], [SPIRIT 2025 (trial protocols)], [53], [Landscape US Letter.],
  [`stard`], [STARD 2015 (diagnostic accuracy studies)], [34], [Portrait A4.],
  [`strobe.cohort`], [STROBE (cohort studies)], [22], [Portrait A4.],
  [`strobe.case_control`], [STROBE (case-control studies)], [22], [Portrait A4.],
  [`strobe.cross_sectional`], [STROBE (cross-sectional studies)], [22], [Portrait A4.],
)

Every entry is transcribed from its official source document, including its citation and license notice --- reproduced verbatim in the "citation" block at the bottom of `checklist.pdf` --- and its real column widths and section colors, read directly from the source file rather than guessed. `strobe` is itself a dictionary of the three study-design variants above rather than one single checklist: there is no fourth, "combined" variant, since that source bundles all three designs' wording into a single item per row, which doesn't fit the one-description-per-id shape every other checklist here uses.

A checklist is plain data, as #link(<sec-quickstart>)[the quickstart] already showed --- nothing about `check()`, `na()`, `render-checklist`, or the `checklist(...)` satellite is specific to CONSORT or to any built-in grid above. A project with its own house checklist, or an emerging reporting guideline not built in yet, simply passes its own dictionary of the same shape in `checklist:` instead.

= Checkitoff in the contexture ecosystem <sec-ecosystem>

Checkitoff is one of two packages built on `contexture`, a small shared package neither of them ships duplicated logic for. This chapter explains what `contexture` actually contributes, introduces the other package built on it, and covers what changes when both are used together.

== What `contexture` does

Everything in this manual that looks up a *real* page number across two documents --- `checklist.pdf` citing exactly where in `manuscript.pdf` each item landed --- relies on Typst's experimental bundle export, which lets one compile produce several documents that can query each other's final layout. `contexture` is the small toolkit that turns that raw capability into something a package author can build on without reinventing it each time:

- an *anchor* primitive --- mark a spot in one document, read it back from any other, by its real page;
- a *shared compile pilot* (`bundle`) --- the single point that ever calls Typst's own `document(...)`, so that checkitoff's grid and, say, another package's own generated document can both be listed side by side without competing to own the compile;
- two independent *compile flags*, `variant` and `preview` --- `preview` is what powers `--input preview=true` throughout this manual; `variant` is a second, independent axis a package can use for its own purposes (palimpsest uses it for clean vs. tracked-changes output, below);
- a shared *diagnostics* mechanism and `strict` flag --- what every warning marker and `strict: true` in this manual are actually built from.

`checkitoff.check()` is a thin wrapper around `contexture`'s anchor primitive; `checklist(...)` is a thin wrapper around its shared compile pilot. None of this needs to be learned to use checkitoff as documented above --- it's mentioned here because the same foundation is shared with the package below, which is what makes combining the two straightforward rather than a rewrite.

== `@preview/palimpsest`: manuscript revisions and reviewer letters

`palimpsest` is a sibling package for a different problem: tracking changes made to a manuscript during peer review (`add`, `del`, `rep`, anchored to a specific reviewer comment), and generating the tracked-changes manuscript and a reviewer response letter that cites the manuscript's real pages --- down to quoting the exact revised wording next to each response, if wanted. See `@preview/palimpsest`'s own manual for the full picture; nothing in it is needed to use checkitoff on its own.

== Combining the two

Checkitoff's `checklist(...)` and palimpsest's `letter(...)` are both just descriptions of a document to build, in the same sense as `checklist(...)` was introduced in #link(<sec-pilot>)[Wiring a real project] --- listing both under the same `documents:` produces, from one compile, a manuscript, its tracked-changes companion, a reviewer response letter, and a completed reporting-guideline grid, all citing each other's real page numbers:

#code(
  "#show: contexture.bundle.with(\n" +
  "  documents: (\n" +
  "    palimpsest.letter(exchanges: my-exchanges),\n" +
  "    checkitoff.checklist(checklist: checklists.consort),\n" +
  "  ),\n" +
  ")\n\n" +
  "#include \"manuscript.typ\""
)

Two rules matter once both packages might touch the same span of text:

+ *Never nest `check(...)` and `passage(...)` inside each other's body, in either direction.* Each wraps its own rendering in a way the other's structural scan can't see through, so nesting either way produces a false diagnostic.
+ *Don't call `check(...)` and `passage(...)` as two independent, rendering siblings on the exact same wording, either.* Nothing stops you, and nothing diagnoses it --- but both functions render their own body, so the same text prints twice, plainly duplicated in `manuscript.pdf`. This only bites when a reviewer's requested change genuinely *is* the manuscript's answer to a checklist item; two unrelated spans, the common case, have nothing to duplicate.

For that second case, use the bare `check(id)` form instead, #link(<sec-quickstart>)[introduced earlier]: `passage(...)` stays the one call that renders the text and carries its tracked-changes marks, `check(id)` only registers the item's coverage, with nothing left to duplicate or nest.

`@preview/contexture`'s own manual walks through this exact combination end to end, including compiling the tracked-and-preview manuscript together, in its chapter "Composing independent packages" --- the package-agnostic version of the two rules above. `@preview/palimpsest`'s manual covers its own side of it, under "Combining with another `contexture` package."

== Where to go next

- The mechanics behind all of this, on their own, with no notion of checklists or revisions attached: `@preview/contexture`'s manual.
- Tracked manuscript revisions and reviewer response letters that cite the real pages: `@preview/palimpsest`'s manual.
- Everything about reporting-guideline checklists on their own: the rest of this manual, from #link(<sec-quickstart>)[Your first checklist] onward.
