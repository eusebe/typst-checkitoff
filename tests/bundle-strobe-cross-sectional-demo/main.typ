#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Smoke test: STROBE (cross-sectional) — confirms this third variant's
// distinct wording (item 6: no matched-studies sub-point at all; item
// 12(d): sampling strategy; item 15: no "over time" phrasing) transcribed
// correctly and renders without error.

#show: contexture.bundle.with(
  template: body => {
    set text(size: 11pt)
    body
  },
  documents: (checklist(checklist: checklists.strobe.cross_sectional),),
)

#include "manuscript.typ"
