set dotenv-load

container_runtime := env_var_or_default("CONTAINER_RUNTIME", "podman")

# Configure aliases
alias b := build
alias d := debug
alias c := clean

# Print all targets
@help:
    just -l

# Create folder
@_create-folder folder:
    mkdir -p {{ folder }}

# Minify all images (requires `imagemin-cli`, `imagemin-pngquant`)
@minify-images:
    {{ container_runtime }} run --rm -v ./data/images:/tmp/images:Z funbox/optimizt:latest /tmp/images

# Build the disposition
@disposition: (_create-folder "out/pandoc")
    pandoc dhbw/disposition.md --citeproc --bibliography=bibliographie.bib --csl data/pandoc/acm.csl -s -o out/pandoc/disposition.pdf --from markdown --template data/pandoc/eisvogel.latex --toc --listings --number-sections --top-level-division=chapter -V geometry:a4paper

# Build the document
@build:
    latexmk --shell-escape -pdf -output-directory="out" -aux-directory="out" -pdflatex="pdflatex -interaction=nonstopmode" dokumentation.tex

# Build the document in debug mode
@debug:
    latexmk --shell-escape -pdf -output-directory="out" -aux-directory="out" -pdflatex="pdflatex" -g dokumentation.tex

# Clean up auxiliary files
@clean:
    latexmk -output-directory="out" -aux-directory="out" -c
