#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

#let tiny = (
  name: "TINY",
  full-name: [Tiny reporting checklist],
  items: (
    (section: "Methods", topic: "Outcome assessment", group: none, id: "6a",
      description: [How the primary outcome was assessed.]),
  ),
)

#show: contexture.bundle.with(
  documents: (checklist(checklist: tiny),),
)

// check("6a") with no body registers item "6a" here without rendering
// anything at all --- the sentence itself is printed directly, right
// below, exactly once. Compare with marks-check-basics.typ: same
// manuscript wording, but check(id, body) both anchors AND renders
// (with a highlight box under preview:true); check(id) only anchors.
The primary outcome was change in disease activity score from baseline
to week 12, assessed by a rater blinded to group assignment. #check("6a")
