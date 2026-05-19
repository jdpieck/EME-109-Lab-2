#import "template.typ": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/oasis-align:0.3.3": *



// #raw(
//   read("find-coef.r"),
//   block: true,
//   lang: "r",
// )
// 
= Pressure vs. Angle

From the lab, we recorded the following data.

#let data = csv("cylinder-rotation-data.csv")

#[
  #set text(.8em)
  #figure(
  table(
    columns: (1in, 1in, 1in, 1in),
    ..data.flatten()
  ),
  caption: [Tabulated data recorded from cylinder experiment recorded during lab session.],
) <cylinder-data>

]

To be able to plot the manometer pressures in Pascals against the tap angle, we need to convert the units of the cylinder manometer by multiplying by 1000. To get the airspeed manometer into Pa, we need to use the following equation to turn the height of water into pressure.

$ P = rho_"water" dot g dot h_"water" $

Plotting this, we get @prob-1.

#let data = json("cylinder_rotation_processed.json")

#figure(
  lq.diagram(
    title: [Gage Pressures (Pa) vs. Cylinder Angle $theta$],
    xlabel: [Cylinder Angle $theta$], 
    ylabel: [Gage Pressures (Pa)],
    width: 100%,
    height: 8cm,
    legend: (position: bottom + right),

    lq.plot(
      data.pressure_tap_angle, 
      data.cylinder_manometer,
      label: [Cylinder Manometer]
    ),
    lq.plot(
      data.pressure_tap_angle,
      data.airspeed_manometer,
      label: [Airspeed Manometer]
    )

  ),
  caption: [Plot of the measured gauge pressures as a function of the angle $theta$ on the cylinder surface.]
) <prob-1>


= Pressure Coefficient vs. Angle

To find the experimental pressure coefficient $C_p$, we use the equation provided to us in the lab manual. 
$
  C_p  = (p_s - p_infinity)/(1/2 rho V^2)
$

The recorded data from the lab already gives us the manometer values in gauge pressure, so we can plug it into the numerator as is. Similarly, the denominator is simply the expanded form of the dynamic pressure which we recorded with the Pitot-static tube. We simply the equation to the following:
$
  C_p = frac(P_"cylinder surface", P_"dynamic")
$

We compare this with the inviscid flow $C_p$ as defined by the following equation:
$
  C_p = 1 - 4 sin^2 theta
$
// #show figure: set block(breakable: false)

Running the data, we get @prob-2.

#let data = json("c_p.json")
#figure(
  lq.diagram(
    title: [Experimental and Inviscid Flow Pressure Coefficient vs. Cylinder Angle $theta$],
    xlabel: [Cylinder Angle $theta$], 
    ylabel: [Pressure Coefficient ],
    width: 100%,
    height: 8cm,
    legend: (position: bottom + right),

    lq.plot(
      data.pressure_tap_angle, 
      data.c_p_exp,
      label: [Experimental]
    ),
    lq.plot(
      data.pressure_tap_angle,
      data.c_p_inv,
      label: [Inviscid]
    )

  ),
  caption: [Plot of the experimental and inviscid flow presure coefficients as a function of the angle $theta$ on the cylinder surface.]
) <prob-2>

Comparing the experimental and inviscid coefficients, we can see that they are closely aligned until after 80#sym.degree, where the experimental data peaks earlier before leveling off at about $C_p = -1.0$. The inviscid flow by definition assumes that there is no friction in the flow, hence why the coefficient is able to recover fully after moving about the cylinder. The presence of friction in the experimental creates turbulence after the wake, decreasing the speed of the flow and increasing its pressure. This is what causes the difference in pressure coefficients.   

= Finding Pressure Drag
The lab manual gives us the following equation to calculate the pressure drag. 
$
  D_p = 2 R L integral ^ pi _ 0 ( p_s - p_infinity) cos theta d theta
$

To compute this numerically, we must perform a trapezoidal remains sum represented with the following equation.

$
  D_p approx 2 R L sum ^(n - 1) _ (i = 1) (frac(Delta P_i cos theta_i + Delta P_(i + 1) cos theta_(i + 1), 2)) Delta theta_i  
$

Implementing this in code (@script) and solving, we find that the *resulting drag force is approximately 4.8525 N.* 

= Published Pressure Drag
Based on the fluid mechanics textbook by White @White_2008 Table 7-3, if we approximate the cylinder as a having a infinite length to diameter ratio, the drag coefficient for the body is 1.2.  

We can use this drag coefficient and the following equation to find the equivalent drag force on the cylinder, where the impacted surface is the cross-sectional area of the cylinder $ A = 2 R  L$.

$ F_d = C_d dot 1/2 rho_"air" u_infinity ^2 dot A $

Using the proper quantities, we find the *theoretical drag force $F_d$ is 5.6095 N. * 

= Comparing Drag Force

= Backend Processing Code <script>
The following was created based off of the equations provided in the lab manual. The equations were implemented in code with the help of a LLM. 

#raw(
  read("script.r"),
  block: true
)