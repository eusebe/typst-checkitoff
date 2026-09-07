#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Generality test: STROBE (cohort) — exercises id-display (items 8, 13,
// 14, 15 show as "8*"/"13*"/"14*"/"15*" in the No column while check()
// still matches on the plain id), a multi-paragraph description within a
// single item (items 1, 6, 12, 13, 14, 16 each bundle several lettered
// sub-points in one cell, unlike CONSORT's one-id-per-sub-point
// convention), and a plain black-and-white table (no section/group fill
// at all, unlike every other checklist in this package).

#show: contexture.bundle.with(
  template: body => {
    set text(size: 11pt)
    set heading(numbering: "1.")
    body
  },
  documents: (checklist(checklist: checklists.strobe.cohort),),
)

#include "manuscript.typ"
