#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// "tiny" has no style: field of its own, so it renders with checkitoff's
// package-default-style until set-style() below overrides it.
#let tiny = (
  name: "TINY",
  full-name: [Tiny reporting checklist],
  items: (
    (section: "Methods", topic: "Outcome assessment", group: none, id: "1",
      description: [How the primary outcome was assessed.]),
    (section: "Methods", topic: "Randomisation", group: none, id: "2",
      description: [How the allocation sequence was generated.]),
  ),
)

#set-style(
  columns: (22%, 6%, 1fr, 12%),
  header-fill: rgb("#2e3436"),
  header-text-color: white,
  section-fill: rgb("#eeeeec"),
)

#show: contexture.bundle.with(
  template: body => {
    set page(width: 16.6cm, height: auto, margin: 12pt)
    body
  },
  documents: (checklist(checklist: tiny),),
)

#check("1")[The primary outcome was assessed by a rater blinded to group
  assignment.]

#check("2")[Participants were randomly assigned via a computer-generated
  sequence.]
