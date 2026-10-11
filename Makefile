#
# Makefile for the ACM TechBrief template
#
# Builds the PDFs with LuaLaTeX (needed for the OpenType fonts) and
# biber, against the unmodified acmart class in acmart-primary/.
#
#   make                  build your-techbrief.pdf (the default)
#   make DOC=mybrief      build mybrief.tex (with mybrief.bib) instead
#   make examples         build techbrief-sample.pdf and techbrief-template.pdf
#   make clean            remove build products (keeps the PDFs)
#   make distclean        remove build products and PDFs
#

DOC      ?= your-techbrief
EXAMPLES  = techbrief-sample techbrief-template
ACMART    = acmart-primary

# Trailing ':' keeps the standard TeX search path after ours, so the
# acmart class and its biblatex styles in $(ACMART) take precedence over
# any older copies installed with the TeX distribution.
export TEXINPUTS := .:$(ACMART)//:

LATEXMK = latexmk -lualatex -interaction=nonstopmode -halt-on-error -file-line-error

STYLE   = techbrief.sty techbrief-logo.tex techbrief-cover.tex

.PHONY: all examples clean distclean

all: $(DOC).pdf

examples: $(EXAMPLES:%=%.pdf)

%.pdf: %.tex %.bib $(STYLE)
	$(LATEXMK) $<

clean:
	for d in $(DOC) $(EXAMPLES); do \
	  latexmk -c $$d.tex; \
	  rm -f $$d.bbl $$d.bcf $$d.run.xml $$d.xmpi $$d.bbl-SAVE-ERROR; \
	done

distclean: clean
	for d in $(DOC) $(EXAMPLES); do latexmk -C $$d.tex; done
