#import "template.typ": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/oasis-align:0.3.3": *



// #raw(
//   read("find-coef.r"),
//   block: true,
//   lang: "r",
// )
// 
= Fs

From the lab, we recorded the following data.

#let data = csv("cylinder-rotation-data.csv")

#figure(
  table(
    columns: 4,
    ..data.flatten()
  ),
  caption: [],
) <cylinder-data>

To be able to plot the manometer pressures in Pascals against the tap angle, we need to convert the units of the cylinder manometer by multiplying by 1000. To get the airspeed manometer into Pa, we need to use the following equation.

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


=

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

= Backend Processing Code <script>
The following was created based off of the equations provided in the lab manual. The equations were implemented in code with the help of a LLM. 

#raw(
  read("script.r"),
  block: true
)