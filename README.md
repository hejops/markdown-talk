# templates

This repository is a fork of
[markdown-talk](https://github.com/ihrke/markdown-talk) that contains a
collection of templates for quickly writing presentations (in Markdown) and
scientific reports (in LaTeX). Modifications have been made to fit my specific
use cases.

The Makefile details how the translation works. If you are on Linux, simply
calling `make` in the parent directory will compile the report to a PDF if all
dependencies are installed. Edit the variables in the Makefile to choose a
theme (check [this webpage](http://deic.uab.es/~iblanes/beamer_gallery/) for a
gallery).

Although writing in Markdown is (in my opinion) much faster and less tedious
than trying to set up beamer autocompletion in LaTeX, the Pandoc conversion
still has some minor quirks, so fiddling with the .tex output will often be
necessary. To avoid unnecessary trouble, avoid using columns on slides with
citations.

`guard.sh` is a script that calls `make` whenever any changes in the directory
are written. I personally have no need for it because I have my editor
recompile automatically after every write.

## Dependencies

- [pandoc (version >= 1.16)](http://pandoc.org/)
- [pandoc-fignos](https://github.com/tomduck/pandoc-fignos)
- [pandoc-citeproc](https://github.com/jgm/pandoc-citeproc)
- a [latex](https://www.latex-project.org/)-distribution (e.g., [texlive](https://www.tug.org/texlive/)) including [bibtex](http://www.bibtex.org/)
- [latex-beamer](https://ctan.org/pkg/beamer?lang=en)

_NOTE_: Pandoc 1.16 is recommended because image-attributes are not available
before that version.

---

Matthias Mittner <matthias.mittner@uit.no>
