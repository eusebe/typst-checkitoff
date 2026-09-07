#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// The recommended idiom for an item whose content straddles a page break
// (no automatic span detection): a check() call at the start of the
// passage, and a second check() call with the *same* id right after the
// page break. pages-of's dedup means this naturally reports both pages,
// not one merged range and not just the first page.

#show: contexture.bundle.with(
  template: body => {
    set page(paper: "a4", margin: 2.5cm)
    set text(size: 11pt)
    body
  },
  documents: (checklist(checklist: checklists.consort),),
)

= Methods

#check("13")[
  The intervention consisted of a daily 10 mg dose of Drug X, administered
  orally with food, for a total of 12 weeks. The comparator was a
  matching placebo tablet, identical in appearance, taste and packaging,
  administered on the same schedule.
]

#lorem(200)
#pagebreak()

#check("13")[
  As introduced above, the comparator (placebo) was manufactured by the
  same facility as Drug X to guarantee identical appearance, and both
  were dispensed in blister packs labelled only with the participant's
  allocation number.
]

= Results

#lorem(30)
