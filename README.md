# ACM TechBrief LaTeX template

A LaTeX template that reproduces the layout of the
[ACM TechBriefs](https://www.acm.org/public-policy/techbriefs) published by
the ACM Technology Policy Council, built on the **unmodified**
[`acmart`](https://github.com/borisveytsman/acmart) class.

All page furniture (banner, running heads, frame, footers, back-page panel,
ACM TPC logo, Creative Commons badge, cover art) is vector, and every
typeface is free.

| File | Purpose |
| --- | --- |
| `techbrief-template.tex` / `.bib` | Blank TechBrief to copy and fill in |
| `techbrief-sample.tex` / `.bib` | Complete worked example: Issue 18, *Autonomy, Opportunities, and Challenges of Action-Taking AI Systems* |
| `techbrief.sty` | The TechBrief layout, loaded after `acmart` |
| `techbrief-cover.tex` | Default cover art (TikZ) |
| `techbrief-logo.tex` | ACM Technology Policy Council logo (TikZ) |
| `acmart-primary/` | The acmart class, unmodified. 2026/08/16 v2.20. Downloaded from https://www.acm.org/publications/proceedings-template |
| `Makefile` | Builds everything |

## Quick start

```bash
cp techbrief-template.tex mybrief.tex
cp techbrief-template.bib mybrief.bib
# edit mybrief.tex and mybrief.bib, then:
make DOC=mybrief
```

`make` on its own builds `techbrief-sample.pdf` and `techbrief-template.pdf`.

Note: This works on MacOS and Linux. If you are working on Windows, we
recommend operating inside WSL (Windows Subsystem for Linux).

### Requirements

A recent TeX Live (2025 or later) with `lualatex`, `biber` and `latexmk`.
Everything else ships with TeX Live:

- **Fonts:** Source Serif Pro, Source Sans Pro, DejaVu Sans, `ccicons`
- **Packages:** `fontspec`, `tikz`, `tcolorbox`, `enumitem`, `colortbl`,
  `biblatex`

The document must be compiled with **LuaLaTeX** (XeLaTeX also works), since
the layout uses OpenType fonts. The Makefile puts `acmart-primary/` first on
the TeX search path so that its `acmart.cls` and biblatex styles are used,
even when TeX Live ships an older copy.

## Formatting your TechBrief

### Preamble

```latex
\documentclass[acmlarge,nonacm,natbib=false]{acmart}
\usepackage{techbrief}
\addbibresource{mybrief.bib}

\acmDOI{10.1145/XXXXXXX}          % back page
\acmISBN{979-8-4007-XXXX-X}       % back page
\techbriefissue{Spring 2026}{18}  % footer of every page
\techbriefacknowledgments{...}    % back-page panel
```

All three class options are required:

- `acmlarge` gives the single-column US Letter base.
- `nonacm` removes the ACM journal furniture.
- `natbib=false` lets `techbrief.sty` load biblatex.

### Title, authors and banner

```latex
\begin{document}
\title[Short Title for the Running Head]{Full Title of the TechBrief,\\
  on No More Than Two Lines}
\author{First Author}
\author{Dr.~Second Author}
\author{Third Author}
\maketechbrief
```

- The banner title is set in two lines at most, 365bp wide; use `\\` to
  choose the break.
- The optional short title appears in capitals in the running head on
  pages 2 onward. Keep it under about 40 characters, or it will collide
  with the TechBriefs wordmark.
- Only author names are printed, as "by A, B, and C". acmart's
  affiliation commands are not needed.
- `\maketechbrief` paints the banner and footer panel on page 1 and
  positions the body frame below the banner.

### Body

Everything between the banner and the back page goes inside
`techbriefbody`, the ruled frame. The frame breaks across pages
automatically.

```latex
\begin{techbriefbody}
Opening paragraphs...

\section*{Key Policy Dimensions}

\runinhead{Legal Responsibility and Liability.} Paragraph text...

\begin{itemize}
\item A point.\cite{key}
  \begin{itemize}
  \item A sub-point.
  \end{itemize}
\end{itemize}

\begin{takeaway}
An italic one-sentence summary.
\end{takeaway}

\section*{Conclusion}
...
\end{techbriefbody}
```

| Command | Result |
| --- | --- |
| `\section*{...}` | Navy 14bp heading (numbering is off, so `\section` works too) |
| `\runinhead{Title.}` | Bold run-in head that starts a paragraph |
| `itemize` | Navy bullets; one level of nesting is styled |
| `takeaway` | Italic summary paragraph; `\begin{takeaway}[12bp]` indents it to the bullet text |
| `\cite{key}` | Superscript citation number; `\cite{a,b}` gives "6,7" |

Subsections are not part of the TechBrief design and are not styled.

### Tables

Floats cannot go inside the frame, so tables are set in place:

```latex
\begin{techbrieftable}{Differences between chat-based AI and agentic AI systems}
    {L{115.3bp}L{171.7bp}L{228.6bp}}
  \rowcolor{tbblue}
    & \tbhead{Chat-based AI} & \tbhead{Agentic AI} \tbheadend
  \tbrowhead{Primary mechanism} & Produces content... & Plans and executes... \\
  \tbrowhead{Human role}        & User reviews...     & User sets goal...     \\
\end{techbrieftable}
```

- `L{width}` is a ragged-right column whose width includes a 6bp gutter.
  The widths should add up to 515.6bp.
- End the blue header row with `\tbheadend`, and every other row with `\\`.
- The caption is numbered automatically ("Table 1:").

### Figures

```latex
\begin{techbrieffigure}{Caption text}
  \includegraphics[width=\linewidth]{diagram.pdf}
\end{techbrieffigure}
```

Figures are also set in place, with the same caption style ("Figure 1:").
Prefer vector graphics (PDF or TikZ).

### Back page

```latex
\techbriefbackpage
\printbibliography
\end{document}
```

`\techbriefbackpage` starts the final page. The references are printed at
the top, numbered in citation order. The *Additional Information* and
*Acknowledgments* panel, DOI, ISBN and license badge are drawn at the foot
automatically.

The references must end above the panel, about 480bp of 7bp text. If they
overlap it or run onto another page, the build log shows a
`Package techbrief Warning`; shorten them.

### References

References use biblatex with acmart's `acmnumeric` style, so entries follow
the ACM reference format. Useful entry types:

- `@article`: blogs and news, with `journal` set to the publication name
- `@techreport`: reports; set `type = {}` to suppress "Tech. rep."
- `@inproceedings`
- `@misc`: arXiv preprints, using `eprint` and `archiveprefix = {arXiv}`
- `@online`: web pages, using `lastaccessed`

Use `date = {YYYY-MM-DD}` for exact dates. Titles are printed as entered,
with no automatic case changes.

## Customizing

*This information is for maintainers; authors should not customize the TechBrief style.*

**Cover art.** The art fills a 202.9 × 201.1bp area at the top right of
page 1. Replace it per issue in the preamble:

```latex
\techbriefcover{\includegraphics[width=202.9bp,height=201.1bp]{cover.pdf}}
```

You can also pass a `tikzpicture`. `techbrief-cover.tex`, a vector
redraw of the Issue 18 cover, is a model; it draws in the original
artwork's pixel coordinates and generates its circuit traces from a fixed
random seed.

**Boilerplate.** The TPC blurb on page 1 (`\tb@tpcblurb`) and the
*Additional Information* text (`\tb@additionalinfo`) are standard ACM text
defined in `techbrief.sty`. Edit them there if ACM updates the wording.

**Copyfitting.** The layout uses fixed leading, as the original does, so a
paragraph that runs one line long can push a heading to the next page. Use
`\looseness=-1` before the paragraph to ask TeX to set it one line shorter.
The sample uses this once, on page 1.

## Design notes

The layout was measured from the published Issue 18
([doi:10.1145/3819832](https://doi.org/10.1145/3819832)). All dimensions in
`techbrief.sty` are in big points (`bp`), so they can be checked directly
against the PDF. In the sample, every body line on pages 1–3 lands on the
same baseline as the original. Banners, footers, frames, table rows,
headings and superscripts match within 0.1bp.

| Original typeface | Used for | Free replacement |
| --- | --- | --- |
| Arnhem | body, headings, table, references | Source Serif Pro (Black for headings) |
| Verdana | banner, title, byline, running head | DejaVu Sans (same widths within 1%) |
| Myriad Pro | footers, TPC blurb | Source Sans Pro (same widths within 0.3%) |

**acmart is not modified.** `techbrief.sty` works only through the class's
supported options and hooks:

- `geometry` is reset for the page.
- Headings are styled through acmart's `\@secfont` hook, because acmart
  forbids redefining `\section`.
- The frame is a breakable `tcolorbox`.
- All page furniture is drawn in a `shipout/background` hook.

The build log contains one expected warning,
`Unused global option(s): [natbib=false]`. acmart's own biblatex samples
produce the same one.

## Make targets

| Target | Action |
| --- | --- |
| `make` | Build `techbrief-sample.pdf` and `techbrief-template.pdf` |
| `make DOC=name` | Build `name.tex` (with `name.bib`) |
| `make compare` | Write 100 dpi PNGs of the original and the sample to `compare/` |
| `make clean` | Remove build products, keeping the PDFs |
| `make distclean` | Remove build products and the PDFs |
