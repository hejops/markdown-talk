THEME=CambridgeUS
COLORTHEME=crane
TEMPLATE=templates/amsterdam.beamer
PANDOC=pandoc #/usr/local/bin/pandoc
BIBLIOGRAPHY=bibliography.bib
MD_FILES=talk.md
TEX_FLAGS=-interaction=nonstopmode


TEX_FILES:=$(MD_FILES:.md=.tex)
PDF_FILES:=$(MD_FILES:.md=.pdf)
TEMPLATE_FILES:=$(wildcard templates/*.beamer)

all: $(TEX_FILES) $(PDF_FILES)

#%.pdf: %.md $(TEMPLATE_FILES) $(BIBLIOGRAPHY)
#	$(PANDOC) -s -S -t beamer $< -V theme:$(THEME) -V colortheme:$(COLORTHEME) --filter pandoc-citeproc --bibliography $(BIBLIOGRAPHY) --template $(TEMPLATE) -o $@

#%.pdf: %.md $(TEMPLATE_FILES) $(BIBLIOGRAPHY)
#		$(PANDOC) -s -S -t beamer $< -V theme:$(THEME) -V colortheme:$(COLORTHEME) --natbib --bibliography $(BIBLIOGRAPHY) --template $(TEMPLATE) -o $@

%.pdf: %.tex
	# perl is a godawful command
	-perl -i -an -e "s|^\\\(.*biblatex.*)|\\\usepackage[backend=biber, citestyle=numeric, bibstyle=chem-acs, sorting=none, maxcitenames=1]{biblatex}|; print" $(basename $<).tex
	# remove empty slides
	# -0777 needed for multiline replace
	-perl -0777 -i -an -e "s|\\\begin{frame}\n\\\end{frame}||; print" $(basename $<).tex
	-perl -0777 -i -an -e "s|\\\begin{frame}\[allowframebreaks\]{References}\n\\\protect\\\hypertarget{references}{}\n\\\end{frame}||; print" $(basename $<).tex
	# citations on footnote of every slide they appear
	# citations on column slides are to be avoided, as footnotes become abc instead of 123
	-sed -i -r "s|\\\autocite\{|\\\footfullcite\{|g" $(basename $<).tex
	# small footnote
	-sed -i "/\\\begin{document}/i \\\\\setbeamerfont{footnote}{size=\\\tiny}" $(basename $<).tex
	# \setbeamerfont{footnote}{size=\tiny}
	# insert headline after begin document
	# yes, those are FIVE consecutive backslashes, don't ask me why
	-sed -i "/\\\begin{document}/i \\\\\setbeamertemplate{headline}{\\\hspace*{\\\fill}\\\includegraphics[width=.08\\\linewidth]{templates/tum}}" $(basename $<).tex
	-pdflatex $(TEX_FLAGS) $(basename $<)
	-biber $(basename $<)
	-pdflatex $(TEX_FLAGS) $(basename $<)
	-rm -f $(basename $<).aux $(basename $<).out $(basename $<).fls $(basename $<).bbl $(basename $<).vrb $(basename $<).nav $(basename $<).bcf $(basename $<).toc $(basename $<).snm $(basename $<).run.xml $(basename $<).blg

%.tex: %.md $(TEMPLATE_FILES) $(BIBLIOGRAPHY)
		#$(PANDOC) -s -S -t beamer $< -V theme:$(THEME) -V colortheme:$(COLORTHEME) --filter pandoc-citeproc --bibliography $(BIBLIOGRAPHY) --template $(TEMPLATE) -o $@
		# bib style still not acs
		# https://github.com/citation-style-language/styles/blob/master/american-chemical-society.csl
		$(PANDOC) -s -t beamer $< --slide-level=1 -V theme:$(THEME) -V colortheme:$(COLORTHEME) --biblatex --csl=american-chemical-society.csl -V biblio-title:References --bibliography $(BIBLIOGRAPHY) --template $(TEMPLATE) -o $@

watch: $(MD_FILES) $(BIBLIOGRAPHY)
	fswatch -o $^ | xargs -n1 -I{} make

.PHONY : clean
clean :
	-rm $(PDF_FILES) *.aux *.out *.log *.fdb_latexmk *.fls *.synctex.gz *.bbl *.vrb *.nav *.bcf *.toc *.snm *.run.xml
