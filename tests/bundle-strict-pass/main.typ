#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// The positive counterpart to bundle-strict-fail: everything is covered,
// so strict: true should compile cleanly, with no diagnostic anywhere in
// checklist.pdf.

#let tiny = (
  name: "TINY-STRICT-OK",
  full-name: [Tiny checklist — strict-mode success demo],
  items: (
    (section: "Section A", topic: "Topic 1", group: none, id: "s1",
      description: [Fully covered below.]),
    (section: "Section A", topic: "Topic 1", group: none, id: "s2",
      description: [Declared not applicable, with a justification.]),
  ),
)

#show: contexture.bundle.with(
  strict: true,
  documents: (checklist(checklist: tiny),),
)

= Manuscript

#check("s1")[This item is covered here.]

#na("s2", reason: [Not applicable to this manuscript, with a proper
  justification — should not be flagged even under strict mode.])
