// A tiny, made-up checklist — NOT a real reporting guideline — used only
// to isolate each diagnostic case in a short document. Also doubles as a
// regression test for "checklist: takes a data value", the phase-1
// decision that a caller can pass any dictionary of this shape, not just
// checklists.consort.
#let tiny = (
  name: "TINY-TEST",
  full-name: [Tiny test checklist (not a real reporting guideline)],
  items: (
    (section: "Section A", topic: "Topic 1", group: none, id: "t1",
      description: [Covered normally — the ordinary, non-diagnostic case.]),
    (section: "Section A", topic: "Topic 1", group: none, id: "t2",
      description: [Never check()'d or na()'d — demonstrates "non couvert".]),
    (section: "Section A", topic: "Topic 2", group: none, id: "t3",
      description: [check()'d with blank content — demonstrates "contenu vide".]),
    (section: "Section B", topic: "Topic 3", group: none, id: "t4",
      description: [Both check()'d and na()'d — demonstrates the conflict diagnostic.]),
    (section: "Section B", topic: "Topic 3", group: none, id: "t5",
      description: [na()'d twice — demonstrates "déclaré N fois".]),
    (section: "Section B", topic: "Topic 4", group: "Sub-group demo", id: "t6",
      description: [Under a group header, first of a 2-row Topic rowspan.]),
    (section: "Section B", topic: "Topic 4", group: "Sub-group demo", id: "t7",
      description: [Under the same group header, second row of the same Topic rowspan.]),
  ),
)
