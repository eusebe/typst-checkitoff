#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Generality test: PRISMA 2020 has a different number of items, different
// section wording (all-caps bands), different column headers ("Item #",
// "Checklist item", "Location where item is reported"), and — unlike
// CONSORT 2025 — no mid-level "group" heading at all. Nothing in grid.typ
// is CONSORT-specific, so this should render correctly with zero
// checklist-specific code.
//
// Also exercises `set-style(landscape: false)`: PRISMA's own `style:`
// (prisma.typ) defaults to landscape (matching its real US-Letter
// landscape /MediaBox), so this specifically tests that an author's
// explicit override still wins over the checklist's own built-in style —
// the third and most specific layer in `style.typ`'s `effective-style`.

#show: contexture.bundle.with(
  template: body => {
    set page(paper: "a4", margin: 2.5cm)
    set text(size: 11pt)
    set heading(numbering: "1.")
    body
  },
  documents: (checklist(checklist: checklists.prisma),),
)

#set-style(landscape: false)

#include "manuscript.typ"
