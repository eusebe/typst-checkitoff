#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// A realistic-looking (fake) trial report exercising most of the CONSORT
// 2025 checklist at once: most items covered normally, a few left
// uncovered on purpose (there aren't enough plausible sentences in a demo
// manuscript to cover all 42 items — the resulting "not covered" markers
// on checklist.pdf are themselves part of what this test demonstrates),
// plus a handful of deliberate mistakes (unknown id, blank check(),
// na()/check() conflict, duplicate na()) sprinkled in on purpose so their
// diagnostics are visible in checklist.pdf. See manuscript.typ for exactly
// which lines are "deliberate test case" vs realistic filler.
//
// Compile (from the repository root, or with --root pointing here):
//   typst compile --features bundle --format bundle tests/bundle-consort-demo/main.typ
//   typst compile --features bundle --format bundle --input preview=true tests/bundle-consort-demo/main.typ
//
// First compile produces manuscript.pdf + checklist.pdf; second produces
// manuscript.pdf only, with check()'d passages highlighted (see
// src/pilot.typ for why preview never also builds the checklist).

#let demo-template(title: none, body) = {
  set page(paper: "a4", margin: 2.5cm)
  set text(size: 11pt)
  set heading(numbering: "1.")
  align(center, text(size: 1.6em, weight: "bold")[#title])
  v(1em)
  body
}

#show: contexture.bundle.with(
  template: demo-template.with(title: [Effect of Drug X on Outcome Y: a randomised controlled trial]),
  documents: (checklist(checklist: checklists.consort),),
)

#include "manuscript.typ"
