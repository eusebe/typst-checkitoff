#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// EXPECTED TO FAIL TO COMPILE — on purpose. Demonstrates that
// `strict: true` turns a "not covered" diagnostic into a hard compile
// error instead of a soft marker in checklist.pdf. compile.sh treats a
// non-zero exit from this specific directory as a pass, not a failure —
// see compile.sh's comment next to `bundle-strict-fail`.

#let tiny = (
  name: "TINY-STRICT",
  full-name: [Tiny checklist — strict-mode failure demo],
  items: (
    (section: "Section A", topic: "Topic 1", group: none, id: "s1",
      description: [Never covered, on purpose.]),
  ),
)

#show: contexture.bundle.with(
  strict: true,
  documents: (checklist(checklist: tiny),),
)

= Manuscript

This manuscript never calls `check("s1")`. Under `strict: true`, compiling
this bundle must fail with a compile error rather than silently produce a
`checklist.pdf` carrying only a soft warning marker.
