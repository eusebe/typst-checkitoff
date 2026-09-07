#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture
#import "checklist.typ": tiny

// Isolates every diagnostic case grid.typ can raise, one per line, against
// a tiny made-up checklist so each is trivially visible in checklist.pdf
// without scrolling through the full 42-row CONSORT table. See
// manuscript.typ for which line demonstrates which case.

#show: contexture.bundle.with(
  documents: (checklist(checklist: tiny),),
)

#include "manuscript.typ"
