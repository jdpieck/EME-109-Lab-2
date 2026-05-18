#import "template.typ": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/oasis-align:0.3.3": *

#show: template.with(
  title: "Lab #1",
  class: "EME 109",
  page-width: 8.5in,
  page-height: 11in,
)
///////////////////////////////////////////////////


= Opening

= Finding

= Discussion

== Methods

== Analysis

== Results

== Commentary


= Closing


#bibliography("ref.bib", title: "References")

// Provides bibliographical information for any material that is not original and which is cited in the report.

#pagebreak()
#outline(title: "List of Attachments", target: heading.where(supplement: [Appendix])) 

#show: appendix
#include "appendix.typ"