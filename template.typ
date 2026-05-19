#let template(
  title: "", 
  class: "", 
  authors: "Jason Daniel Pieck", 
  emails: "jdpieck@ucdavis.edu",
  page-height: auto, 
  page-width: 8.5in, 
  columns: 2,
  accent: rgb("#063e7e"),
  body
) = {
  
  // Set the document's basic properties.
  set document(
    author: authors, 
    title: [#title - #class]
  )
  
  show link: it => underline(text(accent.lighten(10%), it))

  set text(
    11pt,
    font: "IBM Plex Sans", 
    lang: "en"
  )

  show figure.caption: set text(.9em, fill: accent)
  // show figure.caption.where(body: []): it => it.supplement + [ ] + context it.counter.display()

  show heading.where(level: 1): set text(fill: accent)
  show heading.where(level: 2): set text(fill: luma(20%))
  show heading.where(level: 3): set text(fill: accent.lighten(10%))

  // show heading.where(level: 1): it => context{
  //   if counter(heading).get() != (1, ) {pagebreak()}
  //   block(it)
  // }

  // show heading.where(level: 2): it => context{
  //   if counter(heading).get() != (1, 1) {line(length: 100%, stroke: .25pt)}
  //   v(.2em)
  //   // block(it)
  //   box(it)
  // }

  set footnote(numbering: "*")
  
  // show bibliography: set heading(numbering: "1)")
  // show bibliography: set par(justify: false)
  
  show table: set par(justify: false) 
  show table: set align(left)
  show table.cell.where(y: 0): set text(white, weight: "bold")
  show table.cell.where(y: 0): it => math.bold(it)
  // show table.cell.where(y: 1): set table.cell(fill: blue)
  set table(
    fill: (x,y) =>
      if y == 0 {accent},
    // stroke: frame(none),
    // stroke: (x,y) => (
    //   left: if x == 1 {gray}
    //   )
  )
  show table.cell.where(x: 0): set align(center)    
  show table: set align(center)
  // show table.cell: set align(left)


  // set math.equation(numbering: "(1)")
  show rect: set align(center)
  set par(justify: true)

  set enum(indent: .5em)
  set list(indent: 1em)

  show image: it => box(radius: 3pt, clip: true, it)

  set raw(lang: "MATLAB")
  // Display inline code 
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  
  // Display block code
  show raw.where(block: true): block.with(
    fill: luma(96%),
    inset: 10pt,
    radius: 4pt,
  )

  set page(
    paper: "us-letter", 
    numbering: "1", 
    number-align: right, 
    margin: (
      rest: 1in
      // bottom: .875in,
      // rest: .625in
    ), 
    height: page-height, 
    width: page-width, 
    footer-descent: 40%,
    footer: context{
      set text(8pt, weight: 300)
      smallcaps[#text(fill: accent, weight: "bold")[#title] - #class]
      h(1fr)
      [Jason Daniel Pieck - ]
      text(fill: accent, weight: "bold", counter(page).display("1"))
    }
  )
  
  place(top, float: true, scope: "parent", {
      set text(1.2em, weight: "bold")
      grid(
      columns: (auto, 1fr), 
      align: horizon,
      column-gutter: 1em,

      stack(
        spacing: 0.6em, 
        [To: #title],
        [From: #authors],
      ),

      align(right, 
        stack(
          spacing: 0.6em, 
          [Date: #datetime.today().display("[month repr:long] [day], [year]")],
          [Subject: #class]
        )
      )  
    )
    // grid(
    //   columns: (auto, 1fr), 
    //   align: horizon,
    //   column-gutter: 1em,

    //   stack(
    //     spacing: 0.6em, 
    //     text(weight: 700, 1.75em, fill: accent, title),
    //     text(weight: 300, 1.5em, class),
    //   ),

    //   align(right, 
    //     stack(
    //       spacing: 0.6em,
    //       text(weight: "bold", authors),
    //       link("mailto:" + emails)[#text(.8em)[#emails]],
    //       text(weight: 300, .8em, datetime.today().display("[month repr:long] [day], [year]"))
    //     )
    //   )  
    // )

    v(-.3em)
    line(length: 100%, stroke: .5pt)
    v(-9pt)
    line(length: 100%, stroke: .5pt )}
  )

  
  // Main body.
  body
}

#let appendix(body) = {
    set heading(numbering: "I.I.", supplement: [Attachment])
    show heading.where(level: 1): set heading(supplement: "Appendix")
    show heading.where(level: 3): set heading(outlined: false)

  
  show heading.where(level: 1): it => {
    // pagebreak()
    block[Attachment #counter(heading).display("I -") #it.body]
  }
  counter(heading).update(0)
  body
}

// Display Functions
#let fig(path, cap: none, width: auto) = figure(image(path, width: width), caption: cap)

#let equation-counter = counter("equations")
#let equ(number) = [Equation #numbering("⓵", number)]

#let num = context{
  equation-counter.step()
  let disp = numbering("⓵", ..equation-counter.get().flatten()) 
  $space disp$
}

#let problem-num = counter("prob")
#let prob(content, page-break: true) = context {
  problem-num.step()
  equation-counter.update(1)
  {
    if problem-num.get().first() >= 1 and page-break {pagebreak()}

    if content != [] {
    heading(level: 1, [
      Problem #context problem-num.display() - #content
    ])
  } else {
    heading(level: 1, [
      Problem #context problem-num.display()
    ])
    }
  }
}

#let known(..array) = {
  figure(table(
    columns: 3,
    [Var], [Val], [Description],
    ..array
  ))
}
#let matlab = heading(depth: 2, numbering: none, [MATLAB Code])

#let side(
  first, 
  fig: "ph.svg", 
  flip: false
) = {
  let second = figure(image(fig))
  if flip {
    grid(columns: (auto, 1fr), second, first)
  } else {
    grid(columns: (1fr, auto), first, second)
  }}


#let pyth(var1, var2) = $sqrt((var1)^2 + (var2)^2)$
#let unitcalc(var1, var2, var3) = $frac((var1)ii + (var2)jj + (var3)kk, sqrt((var1)^2 + (var2)^2 + (var3)^2))$
#let vecdisp(var1, var2, var3) = $(var1) ii + (var2) jj + (var3) kk$
#let det(v1, v2, v3, v4 ,v5, v6) = $mat(ii, jj, kk; v1, v2, v3; v4, v5, v6; delim: "[")$
#let mac(content, power) = $lr(angle.l content angle.r) ^ power$

#let answer(content, alignment: center) = align(alignment)[#block(fill: rgb(255,252,0,255), radius: 4pt, inset: 3pt, content)]
#let answer(equation) = block(fill: rgb("#fffda0"), radius: 4pt, inset: .5em, {$ equation $})

#let ans = place(
  horizon + left,
  dx: 1em, 
  rect(
    stroke: rgb("#063e7e"), 
    inset: .3em, 
    h(-1.2pt) + 
    text(
      .8em,
      rgb("#063e7e"), 
      "Ans."
    )
  )
)
// #let ans(content, alignment: center) = align(alignment)[#block(stoke: 1pt, radius: 2pt, inset: 3pt, content)]
// #let ans(equation) = block(stroke: .5pt, radius: 2pt, inset: .4em, {$ equation $})

#let pow(value) = [#math.times 10#super[#value]]
#let powMod(input, order) = {
let modded = calc.round(input*calc.pow(10, order), digits: 2)
$modded ee(- order)$
}


// Rounding
#let r0(num) = str(calc.round(num, digits: 0))
#let r1(num) = str(calc.round(num, digits: 1))
#let r2(num) = str(calc.round(num, digits: 2))
#let r3(num) = str(calc.round(num, digits: 3))
#let r6(num) = str(calc.round(num, digits: 6))


// Shorthand
#let then = $quad arrow.double quad$
#let imp = $&=>$
#let there = $therefore quad $
#let also = $quad \& quad$
#let e(var) = $times 10^(var)$
#let ee(var) = $times 10^(var)$
#let eet(var) = [#math.times\10#super[#var]]
#let tot = "tot"
#let shear = $tau_(x y)$
#let shearp = $tau_(x' y')$
#let avg = "avg"
#let PE = "PE"
#let KE = "KE"
#let ref = "ref"
#let cq = $, quad$

// Chem
#let CO2 = $"CO"_2$
#let CO = $"CO"$
#let SO2 = $"SO"_2$
#let O2 = $"O"_2$
#let OH = "OH"
#let N2 = $"N"_2$
#let H2 = $"H"_2$
#let CH4 = $"CH"_4$
#let H2O = $"H"_2"O"$
#let H20 = $"H"_2"O"$
#let N2 = $"N"_2$
#let C3H8 = $"C"_3"H"_8$
#let C5H12 = $"C"_5"H"_12$
#let C2H5OH = $"C"_2"H"_5"OH"$
#let lbmol = "lbmol"

#let hb = $macron(h)$
#let dhb = $Delta macron(h)$
#let hbf = $macron(h)_f^degree$
#let nf = $dot(n)$
#let nff = $dot(n)_"fuel"$
#let qd = $dot(Q)$
#let sb = $macron(s)$
#let sbf = $macron(s) ^degree$ 
#let da  = sym.harpoons.rtlb
#let gib = $Delta G ^ degree$
#let gibb = $macron(g) ^ degree$


// Units
#let MPA = "MPa"
#let MPa = "MPa"
#let kip = "kip"
#let ksi = "ksi"
#let in2 = "in²"
#let um = "μm"
#let GPa = "GPa"
#let milli = $ee(-3)$
#let micro = $space"μ"$
// #let micro = $ee(-6)$
#let nano = $ee(-9)$
// #let kN = $ee(3) "N "$
#let kN = "kN"
#let MN = $ee(6) "N "$
#let ft = "ft"
#let Nm = "N⋅m"
#let lbf = "lbf"
#let lbfts = "lb⋅ft/s²"
#let kNm = "kN⋅m"
#let fts = "ft/s²"
#let lb = "lb"
#let npm = "N/m²"
#let kg = "kg"
#let m2 = "m²"
#let m4 = "m⁴"
#let new = "N "
#let met = "m "
#let hr = "hr"
#let sec = "sec"
#let ms2 = "m/s²"
#let m3 = "m³"
#let kJ = "kJ"
#let bar = "bar"
#let kW = "kW"
#let degC = "°C"
#let degK= "K"
#let degF= "°F"
#let degR= "°R"
#let net = "net"
#let volt = "V "
#let out = "out"
#let inn = "in"
#let mm = "mm"
#let amp = "A "
#let lbfin2 = "lb/in²"
#let ft3lb = "ft³/lb"
#let btulb = "Btu/lb"
#let btulbmol = "Btu/lbmol"
#let btulbR = "Btu/lb⋅R"
#let m3kg = "m³/kg"
#let kjkg = "kJ/kg"
#let kPa = "kPa"
#let kjkmol = "kJ/kmol"
#let kjkmolK = "kJ/kmol⋅K"
#let kjkgK = "kJ/kg⋅K"
#let mf = $dot(m)$
#let lbs = "lb/s"
#let vel = $arrow(v)$
#let ms = "m/s"
#let kgs = "kg/s"
#let sun = "kJ/kg⋅K"


// Notation
#let dp = $d p$
#let phi = math.phi.alt
#let yy = $macron(y)$
// #let ii = $hat(i)$
// #let jj = $hat(j)$
// #let kk = $hat(k)$
// #let rr = $hat(r)$
// #let RR = $arrow(R)$
// #let FF = $arrow(F)$
// #let ll(var) = $arrow(lambda)_(var)$

// #let NV(var) = $arrow(N)_(var)$
// #let NCA = $arrow(N)_(C A)$
// #let NCB = $arrow(N)_(C B)$
// #let (ax, ay, bx, by, cx, cy, dx, dy) = ($F_A_x$, $F_A_y$, $F_B_x$, $F_B_y$, $F_C_x$, $F_C_y$, $F_D_x$, $F_D_y$)
#let (sfx, sfy) = ($Sigma F_x &= 0 $, $Sigma F_y &= 0 $)
#let (sma, smb, smc, smd, sms) = ($Sigma M_A &= 0 $, $Sigma M_B &= 0 $, $Sigma M_C &= 0 $, $Sigma M_D &= 0 $, $Sigma M_"sec" &= 0  $)
#let (v4, v3, v2, v1) = ($v''''$, $v'''$, $v''$, $v'$)
#let EI = $E I$


// Constants
#let ge = $9.81 space"m/s"^2 $
#let cge = 9.81
#let Na = $6.022ee(23) "g/amu"$
#let cNa = 6.022 // Times 10^23
#let k0 = $9 ee(9) "Vm/C"$
#let ck0 = 9//*calc.pow(10,9)
#let e0 = $1.6 ee(-19) "C "$
#let ce0 = 1.6 // Times 10^(-19)
#let rc = $8.134 J\/"mol" dot "K "$
#let crc =  8.134
#let kel = 273.15
#let ckel = 273.15


#let enthalpy-table(units: "si", temps: (), ..num) = {
  let enthalpy = kjkmol
  let temp = degK
  if units != "si" {
    enthalpy = btulb
    temp = degR
  }

  figure(table(
    columns: temps.len() + 2,
    [Molecule], $hb(T_ref)$, 
    ..temps.map(n => $hb (#n space temp)$),
    ..num
  ))
}

#let find-temp(units: "si", temp-num: 2, temp1, temp2, guess1, guess2, ..num) = {
  let enthalpy = kjkmol
  let temp = degK
  if units != "si" {
    enthalpy = btulb
    temp = degR
  }
  figure(table(
    columns: temp-num + 2,
    [Molecule], $hb(T_ref )$, $hb (temp1 space temp)$, $hb (temp2 space temp)$,
    ..num
  ))

  $
    "1st Guess:"& r0(guess1) enthalpy \
    "2nd Guess:"& r0(guess2) enthalpy
  $
}