#import "../../lib.typ": *
#import "../../../typst-contexture/lib.typ" as contexture

// Regression test for check()'s bare, point-marker form: check(id), no
// body — registers item coverage exactly like check(id, body), but
// renders nothing in the plain compile (a small superscripted id under
// --input preview=true, compile.sh runs this test both ways, no
// highlight box since there's no body to wrap). Exists for the case
// check(id, body) can't cover cleanly: a passage that's already
// rendered by something else and must not be printed a second time. See
// CLAUDE.md, "check(): a point-marker form", for the story.

#let tiny = (
  name: "TINY-POINT-MARKER",
  full-name: [Tiny checklist — check() point-marker regression test],
  items: (
    (section: "Section A", topic: "Topic 1", group: none, id: "a1",
      description: [Covered via check(id) with no body — content is rendered directly, not by check() itself.]),
    (section: "Section A", topic: "Topic 2", group: none, id: "a2",
      description: [Covered via ordinary check(id, body), for comparison in the same grid.]),
  ),
)

#show: contexture.bundle.with(
  documents: (checklist(checklist: tiny),),
)

= Manuscript

// The wording is written once, rendered once, directly — check("a1")
// only registers it as item a1's location, it never touches the layout.
The primary outcome was assessed by a rater blinded to group assignment. #check("a1")

// Ordinary form, for contrast: renders its own body.
#check("a2")[Randomisation used permuted blocks of 4.]
