#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Smoke test: STROBE (case-control) — confirms this second variant's
// distinct wording (item 6: case ascertainment/control selection; item
// 12(d): matching of cases and controls) transcribed correctly and
// renders without error.

#show: contexture.bundle.with(
  template: body => {
    set text(size: 11pt)
    body
  },
  documents: (checklist(checklist: checklists.strobe.case_control),),
)

#include "manuscript.typ"
