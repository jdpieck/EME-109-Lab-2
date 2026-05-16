#import "template.typ": *
// #import "@preview/oasis-align:0.3.0": *
#show: template.with(
  title: "Lab #1",
  class: "EME 109",
  page-width: 8in,
)
///////////////////////////////////////////////////


= Introductory Statement
// Clearly states 1. the context and problem, 2. the assigned task, and 3. the purpose of the memo in 2-3 sentences.

In this lab, we are tasked to create a model for a catapult system with multiple inputs after being drafted into the milliary. While previous engineering classes would tell us to attempt to build a model from first principles, doing so would be very challenging given the interaction of springs and rubber bands in the system. 

Instead, we use a 2#super[3] factorial experimental design to quickly model the system interactions and create a reliable function to predict launch distances. This memo outlines the results of the experimentists performed to create the system model, and an evaluation of the factors present with the models as well as their values. 


= Apparatus
// Describe the apparatus you used.
For this experiment, we use a catapult with the following three inputs:

+ *Launch arm rubber band position $X_1$*, which has six discrete positions between 1 & 5
+ *Band tension position $X_2$* , which has 5 discrete positions between 1 & 4
+ *Cocking angle $X_3$*, which is a continuous input between 135#sym.degree and 165#sym.degree

By modifying each of this inputs, we are able to change the launch distance $Y$. 

= Data
// Describe the data you acquired with some sample data included.

We collected the following data as seen in @data-table. The  2#super[3] factorial design has us test each of the bounds of the inputs with each other to reveal any synergistic effects that may exist in the system.

#let data = csv("data-table.tsv", delimiter: "\t")

#figure(
  table(
    columns: data.len() - 1,
    data.at(0).at(0), ..data.at(0).slice(1).map(it => eval(it, mode: "math")),
    ..data.slice(1).flatten()
    // ..data.flatten()
  ),
  caption: [Recorded data from experiment.]
) <data-table>

Using the script from @script which uses the equations provided in the lab manual, we get the following coefficients.

#figure(
  table(
    columns: 2,
    [Coefficient], [Value],
    $macron(Y)$, [81.915],
    $E_1$, [30.335],
    $E_2$, [40.500],
    $E_3$, [45.670],
    $I_12$, [-1.335],
    $I_13$, [11.835],
    $I_23$, [18.000],
    $I_123$ , [5.165],
  ),
  caption: [Calculated Coefficients]
)
// - $macron(Y) = 81.915$
// - $E_1 = 30.335$
// - $E_2 = 40.500$
// - $E_3 = 45.670$
// - $I_12 = -1.335$
// - $I_13 = 11.835$
// - $I_23 = 18.000$
// - $I_123 =  5.165$

These values can then be entered into the following equation to predict the distance $Y$.

$
 Y_"prediction" =  macron(Y) + E_1/2 X_1 + E_2/2 X_2 + E_3/2 X_3 + I_12/2 X_1X_2 + I_13/2 X_1 X_3 + I_23/2 X_2 X_3 + I_123/2 X_1 X_2 X_3
$

#pagebreak()
= Analysis
== Identifying the Most Important Factor
First looking at the $E$ values, we find that the largest coefficient is $E_3$ which is associated with $X_3$. That said, the coefficient $E_2$ is also quite large, so this alone is not enough to verify that $X_3$ is the most important coefficient. 

Looking at the $I$ values, we see that $I_23$ is the largest. $I_23$ is associated with both $X_2$ and $X_3$, which reinforces the earlier hypothesis that both $X_2$ and $X_3$ are important. Comparing $I_12$ and $I_13$, we see that $I_13$ is much larger, this implying that $X_3$ is more important than $X_2$.

*Therefore, $X_3$ (cocking angle) is the most important factor.*

== Taylor Series Expansion
// 2. Develop a Taylor series expansion of the equation Y = f(X1,X2,X3) about the point (X1,X2,X3) = (0,0,0).


For a multi-variable system, the Taylor expansion follows the following form.

$ f(X_1, X_2, X_3) = f(0, 0, 0) + sum _(i = 1) ^3 frac( partial f, partial X_i) X_i + 1/2! sum _(i = 1) ^3 sum _(j = 1) ^3 frac( partial ^2 f, partial X_i partial X_j) X_i X_j + ... $

Applying this to the equation from the lab manual, we get the following.

$ 
f(X_1, X_2, X_3) = f(0, 0, 0) &+ frac(partial f, partial X_1) X_1 + frac(partial f, partial X_2) X_2 + frac(partial f, partial X_3) X_3 + frac(partial ^2 f, partial X_1 partial X_2) X_1 X_2 + frac(partial ^2 f, partial X_1 partial X_3) X_1 X_3  \ &+  frac(partial ^2  f, partial X_2 partial X_3) X_2 X_3 + frac(partial ^3 f, partial X_1 partial X_2 partial X_3) X_1 X_2 X_3 $

Note that the even though the second order terms have a $1\/2!$ component, the summations mean that for each combination of variables appears twice, thus canceling the $1\/2!$.


$ 1/2! (frac(partial ^2 f, partial X_1 partial X_2) X_1 X_2 + frac(partial ^2 f, partial X_2 partial X_1) X_2 X_1) = frac(partial ^2 f, partial X_1 partial X_2) X_1 X_2 $

== How Do the Partial Derivatives Relate
// 3. Relate the Taylor series partial derivatives to the coefficients in your DOE equation.

Comparing our Taylor expansion to the original equation, we can see the following relations of the coefficients.

#figure(
  table(
    columns: 2,
    [Taylor Series Term], [DOE Coeff.],
    $f(0, 0, 0)$, $macron(Y)$,
    $ frac(partial f, partial X_1) $, $ E_1 / 2 $,
    $ frac(partial f, partial X_2) $, $ E_2 / 2 $,
    $ frac(partial f, partial X_3) $, $ E_3 / 2 $,
    $ frac(partial^2 f, partial X_1 partial X_2) $, $ I _12 / 2 $,
    $ frac(partial^2 f, partial X_1 partial X_3) $, $ I _13 / 2 $,
    $ frac(partial^2 f, partial X_2 partial X_3) $, $ I _23 / 2 $,
    $ frac(partial^3 f, partial X_1 partial X_2 partial X_3) $ , $ I_123 /2 $  ,
  ),
  caption: [Calculated Coefficients]
)

The first order terms can be understood as the sensitivity of each of the factors, while the second and third order terms give us a window into the synergistic effects between each of the combinations of the variables.

// x_1 1 -5 
// x_2 1 - 4
// x_3 165 - 135

== Limits of Applicability
// 4. Discuss the limits of applicability of the DOE equation you used in general terms, i.e., under what conditions would this equation not be applicable?


The equation that we derived *can only be used within the bounds of the data that we tested*. For example, we only tested launch angles between 135#sym.degree and 165#sym.degree. If we wanted to predict the launch distance of a launch from 170#sym.degree, our equation would not be able to accurately predict that. 

The equation also *assumes that the inputs and outputs of the system are related via linear relationships*. If the relationship are actually higher order, then this model could not accurately predict the launch distance. 

Furthermore, if there are other variables that that we may want to change about the system, they are not accounted for in the equations that we have created. 

#pagebreak()
= Conclusions and Recommendations
// Determines and presents the most significant implications or recommendations.

We can see that the Taylor expansion of the provided empirical equation are related by the a series of coefficients which determine the weight of the factors and their respective synergies. This demonstrates that the form of the empirical equation is already the most optimized that it can be for calculations, and that any further optimizations would lose significant accuracy. 

By using the equation, we were able to accurately predict the launch distance of the system, and back solve to hit specific targets. 



#bibliography("ref.bib", title: "References", full: true)

// Provides bibliographical information for any material that is not original and which is cited in the report.


#show: appendix
#include "appendix.typ"