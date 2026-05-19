#import "template.typ": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/oasis-align:0.3.3": *



// #raw(
//   read("find-coef.r"),
//   block: true,
//   lang: "r",
// )
// 
// 
= Adjusted Air Density
While the density of air is given at 1.225 kg/m#super[3], we must adjust it for humidity and temperature. This can be done using partial pressure analysis. For this lab, I have opted to use an online tool @Omni2026, which at a temperature of 21 C#sym.degree and 43% humidity gives a air density of 1.200764 kg/m#super[3].
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
    title: [Gage Pressures vs. Cylinder Angle $theta$],
    xlabel: [Cylinder Angle $theta$ (degree)], 
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


= Pressure Coefficient vs. Angle <pressure-coef>

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
    xlabel: [Cylinder Angle $theta$ (degree)], 
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

= Finding Pressure Drag <exp-drag>
The lab manual gives us the following equation to calculate the pressure drag. 
$
  D_p = 2 R L integral ^ pi _ 0 ( p_s - p_infinity) cos theta d theta
$

To compute this numerically, we must perform a trapezoidal remains sum represented with the following equation.

$
  D_p approx 2 R L sum ^(n - 1) _ (i = 1) (frac(Delta P_i cos theta_i + Delta P_(i + 1) cos theta_(i + 1), 2)) Delta theta_i  
$

Implementing this in code (@script) and solving, we find that the *resulting drag force is approximately 4.8525 N.* 

= Published Pressure Drag <theoretical-drag>
Based on the fluid mechanics textbook by White @White_2008 Table 7-3, if we approximate the cylinder as a having a infinite length to diameter ratio, the drag coefficient for the body is 1.2.  

We can use this drag coefficient and the following equation to find the equivalent drag force on the cylinder, where the impacted surface is the cross-sectional area of the cylinder $ A = 2 R  L$.

$ F_d = C_d dot 1/2 rho_"air" u_infinity ^2 dot A $

Using the proper quantities, we find the *theoretical drag force $F_d$ is 5.4985 N. * 

= Comparing Drag Force
The experimental and theoretical values are quite close to each other, only exhibiting a #r2((5.498539 - 4.8525)/5.498539 * 100)% error in value. The value in the textbook assumes completely laminar flow. As we will discuss in @flow-sep, the flow in the experiment is not completely laminar. The increased turbulence would reduce the total drag the the cylinder experiences, thus reducing the drag coefficient. 

= Flow Separation <flow-sep>
Once again, we can reference the fluid mechanics book from White @White_2008 to find the following figure, which showcases the types of flow separation around a cylinder. 

#figure(
  image(
    "wake.png",
    width: 4in,
  ),
  caption: [Flow separation diagram from White @White_2008.]
)

Our experiment began experiencing flow separation at around 105#sym.degree. 
Comparing this with our data from @prob-2, we find that our flow follows a trend closer to the turbulent model which suggests that flow separation should occur at 120#sym.degree where as laminar flow separation should occur 82#sym.degree.

While the apparatus is designed to create as laminar a flow as possible, we note in @pitot-lat that the flow entering the apparatus is not uniform. This implies the presence of turbulence in the system.  


= Pitot-Static Probe Angle Effects <pitot-angle>
In lab, we collected the following data:

#[
  #let data = csv("pitot-angle.csv")
  #set text(.8em)
  #figure(
  table(
    columns: (1in, 1.5in,),
    ..data.flatten()
  ),
  caption: [Tabulated data of the pitot-static probe as it is rotated.],
) <cylinder-data>

]

We can rearrange the pressure equation to get apparent air speed. 

$ Delta P = 1/ 2  rho_infinity  u_infinity ^2 = rho g h  then u_infinity = sqrt( frac( 2 rho g h, rho_infinity)) $

With this, we get the following: 

#[
  #let data = csv("pitot_angle_processed.csv")
  #set text(.8em)
  #figure(
  table(
    columns: (1in, 1.5in,auto),
    [Probe Angle (degrees)],[Manometer Reading (mmH2O)],[Apparent Airspeed (m/s)],
    ..data.slice(1).flatten()
  ),
  caption: [Tabulated data of the pitot-static probe as it is rotated.],
) <cylinder-data>

]

The apparent speeds only have a standard deviation of 0.345623 m/s, showing a very tight spread and indicating the the effects of the angling the probe are negligible, especially at small angles. 

= Pitot-Static Probe Lateral Transverse Effects <pitot-lat>
Using the same equation as in @pitot-angle, we can find the apparent air speed across the vertical length of the testing apparatus. 
#let data = json("pitot_lateral_processed.json")

#figure(
  lq.diagram(
    title: [Apparent Air Speed vs. Pitot-Static Tube Lateral Transverse ],
    xlabel: [Pitot-Static Tube Lateral Transverse Height (mm)], 
    ylabel: [Apparent Air Speed (m/s)],
    width: 100%,
    height: 8cm,
    legend: (position: bottom + right),

    lq.plot(
      data.probe_location,
      data.u_infinity_m_s

    ),


  ),
  caption: [Plot of the calculated airspeeds as a function height of the pitot-static probe.]
) 
The resultant data shows some fluctuation in the airspeed. Specifically, as the probe crosses the center of the airflow area, we see the speed drop by over a meter per second. This implies that the velocity profile upstream of the cylinder was not uniform, likely due to the proximity of the cylinder to the entrypoint of the air. This may have contributed to some of the apparent turbulence that we see evidence of in other sections of the lab.

#pagebreak()
= Backend Processing Code <script>
The following was created based off of the equations provided in the lab manual. The equations were implemented in code with the help of a LLM. 

#raw(
  lang: "r",
  read("script.r"),
  block: true
)