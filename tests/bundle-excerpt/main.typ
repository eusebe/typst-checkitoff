#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Demonstrates excerpt-of(): re-emitting the real, verbatim content
// anchored by check(), e.g. for a supplementary "compliance appendix"
// listing exact wording next to each item — not part of the official
// CONSORT grid (which only has a page-number column), so this lives in
// the manuscript itself, not in checklist.pdf.

#show: contexture.bundle.with(
  template: body => {
    set page(paper: "a4", margin: 2.5cm)
    body
  },
  documents: (checklist(checklist: checklists.consort),),
)

#include "manuscript.typ"
