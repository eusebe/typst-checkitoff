#import "../../lib.typ": *

This document isolates, one by one, every diagnostic case `checklist.pdf`
must report. Compare each line below against the corresponding row of the
rendered grid.

t1 — the normal case, no diagnostic expected:

#check("t1")[Normal content, correctly covered.]

t2 — never covered: row "t2" in the grid must show
"⚠ item t2: not covered".

t3 — blank content:

#check("t3")[]

t4 — both check() and na() on the same id: the Page cell for "t4" must
show the conflict diagnostic rather than silently picking a side.

#check("t4")[Covered anyway.]
#na("t4", reason: [Declared not applicable here only to test the conflict
  with check().])

t5 — na() declared twice for the same id: the Diagnostics block must list
"na(\"t5\") declared 2 times".

#na("t5", reason: [First declaration.])
#na("t5", reason: [Second declaration — deliberate duplicate.])

t6/t7 — sharing the "Sub-group demo" group and the same Topic: check in
the grid that the Topic cell is properly merged (rowspan) across both
rows, under a single group header.

#check("t6")[First item of the group demonstration.]
#check("t7")[Second item of the same group, same topic.]

An id entirely unknown to the "tiny" checklist, referenced once via
`check()` and once via `na()`: the Diagnostics block must list both, each
with the page where the offending call sits in this manuscript.

#check("zzz")[This id doesn't exist in any grid — unknown id via check().]
#na("yyy", reason: [Neither does this one — unknown id via na().])
