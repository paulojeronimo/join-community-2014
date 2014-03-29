find . -maxdepth 1 -type f -name '*.adoc' ! \( -name attributes.adoc -o -name slides.adoc \) | xargs asciidoctor
