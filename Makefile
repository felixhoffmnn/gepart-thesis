.PHONY: disposition clean build
.DEFAULT_GOAL := build

disposition:
	@echo "Creating Disposition Paper..."
	pandoc dhbw/disposition.md --citeproc --bibliography=bibliographie.bib --csl data/pandoc/acm.csl -s -o out/pandoc/disposition.pdf --from markdown --template data/pandoc/eisvogel.latex --toc --listings --number-sections --top-level-division=chapter -V geometry:a4paper

clean:
	@echo "Cleaning up..."
	latexmk -c -output-directory=out/latex

build:
	@echo "Building the document..."
	latexmk -pdf -synctex=1 -shell-escape -interaction=nonstopmode -output-directory=out/latex dokumentation.tex
