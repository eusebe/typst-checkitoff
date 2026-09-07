#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Generality test: STARD 2015 — exercises blank Topic cells (several
// single-item sections have no Topic label at all in the source, unlike
// every other checklist in this package so far), a Topic reused across
// two different sections ("Participants" appears under both METHODS and
// RESULTS, must not merge across the section boundary), and its own
// portrait US-Letter default with a saturated blue band unlike any other
// checklist here.

#show: contexture.bundle.with(
  template: body => {
    set text(size: 11pt)
    set heading(numbering: "1.")
    body
  },
  documents: (checklist(checklist: checklists.stard),),
)

#include "manuscript.typ"
