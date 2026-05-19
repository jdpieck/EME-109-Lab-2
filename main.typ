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
The purpose of this memo is to present the result of an experiment in which measured viscous fluid flow effects around a circular cylinder in a open-circuit wind tunnel. We were tasked with determining the surface pressure profiles,  observing boundary layer behavior, and computing the total drag force exerted on the cylinder. In this report, we outline our findings and compare them to established measurements.

= Finding
The key findings of the experiment include the derivation of the experimental pressure drag force $D_p$ which was found to be approximately 4.8525 N via numerical integration of the surface pressure data. This aligned closely with available published data that predicted a drag force of 5.4985 N, resulting in a minor error of 11.75%. In addition, we determined that boundary layer separation occurred at an angle of approximately 105#sym.degree, indicating a  turbulent boundary layer before separation.

= Discussion

== Methods
The testing apparatus involved placing a circular cylinder within the test section of an open-circuit wind tunnel. At a free-stream airspeed of 20 m/s as set by the TA, we slowly rotated the cylinder from 0#sym.degree to 180#sym.degree in 10#sym.degree increments. At each of the intervals, we recorded the surface gauge pressure using a surface pressure tap in addition to the free-stream dynamic pressure recorded by a Pitot-static probe and system drag recorded by a mechanical force balance system. We also performed additional evaluations using the Pitot-static probe to determine the velocity profile up-steam.

== Analysis
We began analysis by adjusting the standard air density for the localized laboratory conditions @Omni2026, those being 21°C and 43% humidity respectively. The revealed a new density of $rho$ equals 1.2 kg/m#super[3]. We then converted the cylinder manometer heights to gauge surface pressures in pascals. We determined the experimental pressure coefficient across all tap angles by normalizing the surface gauge pressure against the dynamic pressure obtained from the Pitot-static probe. We then applied a trapezoidal Riemann sum to numerically integrate our surface pressure data over the geometry of the cylinder to calculate the net pressure drag force ($D_p$). Lastly, we used White's published drag coefficient of 1.2 for an infinite cylinder @White_2008 to calculate our theoretical total drag force ($F_d$).  

== Results
We observed that the surface pressure reached its maximum positive peak at the 0° stagnation point, dropped to its lowest negative peak of $-0.6335 "kPa"$ at 80°, and then leveled off into a stable plateau between 130° and 180°. When we plotted our experimental $C_p$ alongside inviscid flow theory ($C_p = 1 - 4 sin^2 theta$), we found that the two models closely aligned until the flow moved past 80°. In our physical results, the pressure coefficient never fully recovered to 1.0 at the rear of the cylinder, remaining stuck near $-1.0$ instead. Our calculations yielded an experimental pressure drag of 4.8525 N, which sits right below our calculated theoretical drag force of 5.4985 N and our average measured force balance drag of ~4.29 N.

== Commentary
We discuss in @pressure-coef the stark differences between our experimental curve and the inviscid flow curve, which we believe to be the result of fluid friction and viscosity. Because inviscid theory completely ignores friction, it assumes the fluid can recover its full pressure behind the body. In our actual test, the pressure gradient past 80° forces the flow to separate. While a laminar boundary layer separates at 82°, our flow profile was closer to the turbulent model, which doesn't separate until 105°. We discovered the reason for this early turbulence when analyzing our lateral traverse data in @pitot-lat; the plot showed that airspeed dropped by over 1 m/s across the center of the tunnel, proving that we did not have a uniform velocity profile upstream of the cylinder.  


= Closing
In conclusion, we demonstrated how viscosity and boundary layer separation dominate the flow profile and net drag forces acting on a cylindrical body. Our lateral traverse data proved that our wind tunnel facility did not provide a completely uniform free-stream velocity profile upstream. We recommend that future laboratory sessions optimize the upstream flow-straightening grids to eliminate these velocity fluctuations before testing. For further reference, please see the references and attachments below

#bibliography("ref.bib", title: "References")

// Provides bibliographical information for any material that is not original and which is cited in the report.
#outline(title: "List of Attachments", target: heading.where(supplement: [Attachment])) 

#pagebreak()

#show: appendix
#include "appendix.typ"