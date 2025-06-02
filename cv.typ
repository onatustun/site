#show heading: set text(font: "Linux Biolinum")

#show link: underline

#set page(
  margin: (x: 0.9cm, y: 1.3cm),
)


#set par(justify: true)

#let chiline() = { v(-3pt); line(length: 100%); v(-5pt) }

#let continuescvpage() = {
  place(
    bottom + center,
    dx: 0pt,
    dy: -10pt,
    float: true,
    scope: "parent",
    [
      #text(fill: gray)
    ]
  )
}

#let lastupdated(date) = {
  h(1fr); text("Last Updated in " + date, fill: color.gray)
}

= Onat Ustun

onat\@ustun.uk |
#link("https://github.com/onatustun")[github.com/onatustun] | #link("https://onatustun.com")[onatustun.com]

== Education
#chiline()

#link("https://typst.app/")[*#lorem(2)*] #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(10)

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(10)

== Projects
#chiline()

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(20)
- #lorem(30)
- #lorem(40)

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) #h(1fr) #lorem(2) \
- #lorem(20)
- #lorem(30)
- #lorem(40)

== Technical Skills
#chiline()

#lorem(5) #h(1fr) #lorem(2) \
- #lorem(20)

#lastupdated("Mar 22, 2025")
