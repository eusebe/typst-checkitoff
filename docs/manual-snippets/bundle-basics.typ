#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// A tiny, made-up grid — not a real reporting guideline — kept small so
// checklist.pdf fits on one page for this illustration; a real project
// passes e.g. `checklists.consort` here instead (see the "Built-in
// checklists" chapter).
#let tiny = (
  name: "TINY",
  full-name: [Tiny reporting checklist],
  items: (
    (section: "Title and abstract", topic: "Title", group: none, id: "1a",
      description: [Identification as a randomised trial.]),
    (section: "Methods", topic: "Sequence generation", group: "Randomisation", id: "10",
      description: [Method used to generate the random allocation sequence.]),
    (section: "Methods", topic: "Allocation concealment", group: "Randomisation", id: "11",
      description: [Mechanism used to conceal the allocation sequence.]),
    (section: "Discussion", topic: "Interpretation", group: none, id: "14",
      description: [Interpretation consistent with results, balancing benefits and harms.]),
  ),
)

#show: contexture.bundle.with(
  template: body => {
    set page(width: 16.6cm, height: auto, margin: 12pt)
    set text(size: 10.5pt)
    body
  },
  documents: (checklist(checklist: tiny),),
)

= Title and abstract

#check("1a")[Effect of Drug X on Outcome Y: a randomised controlled trial.]

= Methods

#check("10")[Participants were randomly assigned via a computer-generated
  sequence.]

#check("11")[Allocation was concealed using sequentially numbered, opaque,
  sealed envelopes.]

= Discussion

This short illustrative manuscript omits a full interpretation section.

#na("14", reason: [Omitted from this compact illustrative example.])
