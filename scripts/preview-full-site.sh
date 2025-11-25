#!/usr/bin/env bash
set -euo pipefail

# Assemble and serve the full multi-course Quarto site locally.
# Requires: quarto, python3 available in PATH.

rm -rf _site
quarto render index.qmd
for d in courses/course-*; do
  if [ -d "$d" ]; then
    quarto render "$d"
  fi
done

mkdir -p _site
if [ -d docs ]; then cp -R docs/* _site/ || true; fi
for d in courses/course-*; do
  cname=$(basename "$d")
  if [ -d "$d/docs" ]; then
    mkdir -p "_site/$cname"
    cp -R "$d/docs"/* "_site/$cname/" || true
  fi
done

if [ -f index.html ] && [ ! -f _site/index.html ]; then
  cp index.html _site/index.html || true
fi

echo "Serving _site at http://localhost:8000 (Ctrl+C to stop)"
cd _site
python3 -m http.server 8000