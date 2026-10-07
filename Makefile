#
# Makefile for the ACM TechBrief template
#
# Builds the PDFs with LuaLaTeX (needed for the OpenType fonts) and
# biber, against the unmodified acmart class in acmart-primary/.
#
#   make                  build the sample and the blank template
#   make DOC=mybrief      build mybrief.tex (with mybrief.bib)
#   make compare          side-by-side PNGs of the sample and the original
#   make clean            remove build products (keeps the PDFs)
#   make distclean        remove build products and PDFs
#

DOCS    = techbrief-sample techbrief-template
ACMART  = acmart-primary

# Trailing ':' keeps the standard TeX search path after ours, so the
# acmart class and its biblatex styles in $(ACMART) take precedence over
# any older copies installed with the TeX distribution.
export TEXINPUTS := .:$(ACMART)//:

LATEXMK = latexmk -lualatex -interaction=nonstopmode -halt-on-error -file-line-error

STYLE   = techbrief.sty techbrief-logo.tex techbrief-cover.tex

ifdef DOC
DOCS    = $(DOC)
endif

.PHONY: all clean distclean compare

all: $(DOCS:%=%.pdf)

%.pdf: %.tex %.bib $(STYLE)
	$(LATEXMK) $<

# Side-by-side PNGs of the original TechBrief and our rendition.
compare: techbrief-sample.pdf
	mkdir -p compare
	pdftoppm -r 100 -png 3819832.pdf compare/original
	pdftoppm -r 100 -png techbrief-sample.pdf compare/ours

clean:
	for d in $(DOCS); do \
	  latexmk -c $$d.tex; \
	  rm -f $$d.bbl $$d.bcf $$d.run.xml $$d.xmpi $$d.bbl-SAVE-ERROR; \
	done

distclean: clean
	for d in $(DOCS); do latexmk -C $$d.tex; done
	rm -rf compare
