#show link: underline

#set page(
  margin: (x: 1.5cm, y: 1.5cm),
)
#set par(justify: true, leading: 0.6em)

#let section-line() = {
  v(-0.2em)
  line(length: 100%, stroke: 0.8pt + gray.darken(10%))
  v(0.6em)
}

#let resume-entry(
  title: none,
  organization: none,
  dates: none,
  body: [],
) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 0pt,
    align: (top, right),
    [
      #text(weight: 700)[#title]
      #if organization != none [
        \ #organization
      ]
    ],
    [
      #text(fill: gray.darken(20%))[#dates]
    ],
  )
  v(0.2em)
  set par(leading: 0.4em)
  body
  v(0.8em)
}

= Onat Ustun

#grid(
  columns: (1fr, auto),
  column-gutter: 0pt,
  align: (top, right),
  [
    College Student \
    Aberdeen, United Kingdom \
    #text(size: 0.85em, fill: gray.darken(20%))[Last Updated: 3 Jun 2025]
  ],
  [
    #link("mailto:o@ust.sh")[o\@ust.sh] \
    #link("https://github.com/onatustun")[github.com/onatustun] \
    #link("https://ust.sh")[ust.sh]
  ],
)

#v(0.8em)

== Education
#section-line()

#resume-entry(
  title: "HND Web Development (including Digital Design & Development)",
  organization: "North East Scotland College (NESCol)",
  dates: "Aug 2023 – Present",
  body: list(
    [Developed a responsive e-commerce platform using React and NodeJS, showcasing proficiency in full-stack development.],
    [Collaborated on various team projects incl a airport booking app, applying Agile methodologies and version control with Git.], 
    [Made bitmap and vector graphics with Adobe Photoshop and Illustrator and implemented them in sites and figma designs following HCI principles.],
  )
)

// #resume-entry(
//   title: lorem(5),
//   organization: lorem(5),
//   dates: "Jan 20xx – Jan 20xx",
//   body: list(
//     lorem(12),
//     lorem(12),
//   )
// )

// == Experience
// #section-line()

// #resume-entry(
//   title: lorem(5),
//   organization: lorem(5),
//   dates: "Jan 20xx – Jan 20xx",
//   body: list(
//     lorem(12),
//     lorem(12),
//   )
// )

== Projects
#section-line()

#resume-entry(
  title: [#link("https://github.com/onatustun/all-season-sauna")[All Season Sauna Website]],
  organization: none,
  dates: "Jan 2025",
  body: list(
    [College assignment to go out and look for a client and build them a website.],
    [Made with React, Nextjs, Typescript, and TailwindCSS.],
    [Produced edits to imagery and made a logo.],
  )
)

== Technical Skills
#section-line()

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
    "TailwindCSS",
    "React",
    "NodeJS",
    "NextJS",
    "Zola",
    "Astro",
    "jQuery",
    "shadcn/ui",
  ),
  "Tools & Platforms": (
    "Git",
    "GitHub",
    "GitHub Actions",
    "Linux",
    "Unix",
    "Netlify",
    "Vercel",
    "npm",
    "Figma",
    "Vim",
    "Helix",
    "Visual Studio Code",
    "Adobe Suite",
    "Photoshop",
    "Illustrator",
  ),
  "Operating Systems": (
    "NixOS",
    "Windows",
    "Arch Linux",
    "Ubuntu",
  ),
  "Methods": (
    "Agile (Scrum)",
    "Waterfall",
    "Object-Oriented Programming",
    "Functional Programming",
    "Asynchronous Programming",
    "Event-Driven Programming",
    "Declarative Programming",
    "Test-Driven Development",
    "Concurrency",
    "Procedural Programming",
    "Debugging",
    "CI/CD",
    "Version Control",
    "API Integration",
  ),
)

#for (category, items) in skills [
  #set par(leading: 0.4em) 
  - #text(weight: 700)[#category:] #items.join(", ")
]
