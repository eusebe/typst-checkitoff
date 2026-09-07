#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Demonstrates the recommended idiom for an item whose content straddles
// a page break (CLAUDE.md, "difficultés anticipées" — no automatic span
// detection in v1): a `check()` call at the start of the passage, and a
// second `check()` call with the *same* id right after the page break.
// `pages-of`'s dedup means this naturally reports both pages, not one
// merged range and not just the first page.

#show: contexture.bundle.with(
  template: body => {
    set page(paper: "a4", margin: 2.5cm)
    set text(size: 11pt)
    body
  },
  documents: (checklist(checklist: checklists.consort),),
)

#include "manuscript.typ"
