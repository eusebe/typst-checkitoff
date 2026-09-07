#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Generality test: SPIRIT 2025 (a trial *protocol* checklist, not a
// results checklist like CONSORT) — exercises its own "Randomization"
// group (grey band, distinct from CONSORT's blue one) inside a section
// named "Methods: Assignment of interventions", and its own US-Letter
// landscape default (vs CONSORT's A4).

#show: contexture.bundle.with(
  template: body => {
    set text(size: 11pt)
    set heading(numbering: "1.")
    body
  },
  documents: (checklist(checklist: checklists.spirit),),
)

#include "manuscript.typ"
