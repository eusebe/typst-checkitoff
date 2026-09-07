#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Isolates every diagnostic case grid.typ can raise, one per line, against
// a tiny made-up checklist so each is trivially visible in checklist.pdf.

#let tiny = (
  name: "TINY-TEST",
  full-name: [Tiny test checklist (not a real reporting guideline)],
  items: (
    (section: "Section A", topic: "Topic 1", group: none, id: "t1",
      description: [Covered normally --- the ordinary, non-diagnostic case.]),
    (section: "Section A", topic: "Topic 1", group: none, id: "t2",
      description: [Never check()'d or na()'d --- demonstrates "not covered".]),
    (section: "Section A", topic: "Topic 2", group: none, id: "t3",
      description: [check()'d with blank content --- demonstrates "blank content".]),
    (section: "Section B", topic: "Topic 3", group: none, id: "t4",
      description: [Both check()'d and na()'d --- demonstrates the conflict diagnostic.]),
    (section: "Section B", topic: "Topic 3", group: none, id: "t5",
      description: [na()'d twice --- demonstrates "declared N times".]),
    (section: "Section B", topic: "Topic 4", group: "Sub-group demo", id: "t6",
      description: [Under a group header, first of a 2-row Topic rowspan.]),
    (section: "Section B", topic: "Topic 4", group: "Sub-group demo", id: "t7",
      description: [Under the same group header, second row of the same Topic rowspan.]),
  ),
)

#show: contexture.bundle.with(
  template: body => {
    set page(width: 16.6cm, height: auto, margin: 12pt)
    set text(size: 9.5pt)
    body
  },
  documents: (checklist(checklist: tiny),),
)

t1 --- the normal case, no diagnostic expected:

#check("t1")[Normal content, correctly covered.]

t2 --- never covered.

t3 --- blank content:

#check("t3")[]

t4 --- both check() and na() on the same id:

#check("t4")[Covered anyway.]
#na("t4", reason: [Declared not applicable here only to test the conflict
  with check().])

t5 --- na() declared twice for the same id:

#na("t5", reason: [First declaration.])
#na("t5", reason: [Second declaration --- deliberate duplicate.])

t6/t7 --- sharing the "Sub-group demo" group and the same Topic:

#check("t6")[First item of the group demonstration.]
#check("t7")[Second item of the same group, same topic.]

An id entirely unknown to the "tiny" checklist, referenced once via
`check()` and once via `na()`:

#check("zzz")[This id doesn't exist in any grid --- unknown id via check().]
#na("yyy", reason: [Neither does this one --- unknown id via na().])
