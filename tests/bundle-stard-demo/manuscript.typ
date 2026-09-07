#import "../../lib.typ": *

= Title and abstract

#check("1")[Diagnostic accuracy of test T for detecting condition C: a
  prospective cohort study.]

= Methods

#check("5")[Data collection was planned prospectively, before either the
  index test or the reference standard were performed.]

#check("6")[Adults presenting with suspected condition C at the
  participating clinic were eligible.]

#check("10a")[The index test was performed by a blinded technician using
  a standardised protocol.]

#check("10b")[The reference standard was histopathological confirmation.]

= Results

#check("19")[@fig-flow shows the flow of participants through the study.]

#figure(
  rect(width: 4cm, height: 2cm, fill: luma(230)),
  caption: [Participant flow diagram.],
) <fig-flow>

#check("20")[@tab-baseline shows baseline characteristics.]

#figure(
  table(columns: 2, [*Characteristic*], [*Value*], [Age, mean (SD)], [58 (14)]),
  caption: [Baseline characteristics.],
) <tab-baseline>

// Item 21a (Distribution of severity in those with the target condition)
// left uncovered on purpose, to show the "not covered" marker inside the
// RESULTS section's own "Participants" topic — the same Topic label
// already used once under METHODS, must not merge across the boundary.

= Discussion

#check("26")[This study was limited by its single-centre design.]
