#show link: underline

#set page(margin: (x: 0.9cm, y: 1.3cm))
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

= Onat Ustun

#grid(
  columns: (auto, 1fr), 
  column-gutter: 0pt,   
  align: (top, right),  
    
  [
    College Student \
    Aberdeen, United Kingdom \
    Last Updated On 3 Jun 2025
  ],
  [
    #link("mailto:o@ust.sh")[email] \
    #link("https://github.com/onatustun")[github] \
    #link("https://ust.sh")[website] \
  ],
)

== Education
#chiline()

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) \
- #lorem(10)

== Experience
#chiline()

*#lorem(2)* #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) \
- #lorem(10)

== Projects
#chiline()

#link("https://github.com/onatustun")[*#lorem(2)*] #h(1fr) 2333/23 -- 2333/23 \
#lorem(5) \
- #lorem(15)
- #lorem(15)
- #lorem(15)

== Technical Skills
#chiline()

#let skills = (
  "Programming Languages": (
    "JavaScript",
    "TypeScript",
    "Python",
    "Java",
    "C#",
    "Rust",
    "Nix",
    "Typst",
  ),
  "Web Technologies": (
    "HTML",
    "CSS",
    "React",
    "NodeJS",
    "NextJS",
    "TailwindCSS",
    "Zola",
    "Astro",
    "shadcn/ui",
  ),
  "Tools & Platforms": (
    "Git",
    "GitHub",
    "GitHub Actions",
    "Netlify",
    "Vercel",
    "npm",
    "Figma",
    "Vim",
    "Helix",
    "Visual Studio Code",
  ),
  "Operating Systems": (
    "NixOS",
    "Windows",
    "Arch Linux",
    "Ubuntu",
  ),
)

#for (category, items) in skills [
  - #text[*#category:*] #items.join(", ")
]
