# lab-materials
Instructions and other materials related to the afternoon labs in the Biostatistics-courses

## Repository Structure

This repository is organized as monorepo to support multiple courses:

```
. 
├── courses/
│   ├── course-1/          # First biostatistics course
│   │   ├── chapters/      # Course content chapters
│   │   ├── labs/          # Lab exercises
│   │   ├── _quarto.yml    # Course-specific config
│   │   └── index.qmd      # Course landing page
│   └── course-2/          # Second biostatistics course
├── index.qmd             # Landing page source
└── _quarto.yml           # Root configuration
```

## Rendering the Website

### Render All Content

From the repository root:

```bash
# Render landing page
quarto render index.qmd

# Render Course 1
quarto render courses/course-1

# Render Course 2  
quarto render courses/course-2

# (and so on for additional courses)
```

### Render a Single Course

From the repository root:

```bash
quarto render courses/course-1
```
## Adding a New Course

1. Create a feature branch (e.g. `add-course-3`).
2. Create directory `courses/course-3/` with needed subfolders (`chapters/`, `labs/`).
3. Copy `_quarto.yml` from an existing course; update title/sidebar (keep `freeze: auto`).
4. Add `index.qmd` plus at least one chapter and one lab file (placeholders fine).
5. Render locally: `quarto render courses/course-3` (creates `courses/course-3/docs/` and `_freeze/`).
6. Verify `_freeze/` exists; commit new course files including `_freeze/`.
7. Update root `index.qmd` to link to the new course.
8. Push branch and open a PR. The PR build will render the new course automatically (workflow loops over `courses/course-*`).
9. Merge PR into `main`; deployment publishes `/course-3/`.
10. To refresh computations later: `quarto render courses/course-3 --execute-refresh` and commit updated `_freeze/`.

## Deployment

This repository deploys to its own GitHub Pages site at:

```
https://biostatistics-psychiatry.github.io/lab-materials/
```

### CI/CD Workflow Overview

- **Pull Requests (PRs)**: Build runs rendering all courses for status checks. No deployment occurs.
- **Merging PRs into `main`**: Build renders once, assembles a unified `_site/` directory, uploads a Pages artifact, then the `deploy-pages` action publishes it.
- **Assembly**: `_site/` is created fresh each run (first step removes any previous `_site`). Contents copied:
   - Root rendered `docs/` (landing page)
   - Each course's rendered `docs/` into `_site/course-1/`, `_site/course-2/`, etc.
- `_site/` is never committed, it only exists inside the workflow runner.

### Freeze & Computation

This project uses `freeze: auto` to cache R computations. This means:

- **First render**: R code executes and results are cached in `_freeze/`
- **Subsequent renders**: Cached results are used (no R execution needed)
- **GitHub Actions**: Only renders HTML from frozen content (no R required)
    - **Render before pushing**: If you add a new chunk or modify code, run a normal render first so the cache populates, then commit any changes under `courses/course-*/_freeze/` before pushing. 

### Local Full-Site Preview
To mimic the CI page assembly, use the helper script:

```bash
bash scripts/preview-full-site.sh
```

Then visit `http://localhost:8000` to inspect the complete project. The script renders all courses, assembles `_site/`, and serves it with Python.
