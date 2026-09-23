# Spec: Course 3 — Regression Models for Binary and Categorical Outcomes

## Objective

Build the third Biostatistics course for the Research School in Clinical Psychiatry. The course teaches PhD students to fit and interpret inferential logistic-regression models in R after they have completed Courses 1 and 2.

The course extends the Course 2 workflow to binary and categorical outcomes. Students will use model-based probabilities, probability differences, confidence intervals, and effect plots as the primary way to answer clinical questions. The course also teaches log-odds and odds ratios as secondary statistical-literacy concepts, so students can recognise and critically interpret the estimates they encounter in research articles without mistaking them for probability differences.

### Learners and prerequisites

Students are assumed to have completed Courses 1 and 2. They can already:

- work in R and Quarto notebooks;
- import, clean, wrangle, and plot STePS data with `tidyverse`, `here`, and `ggplot2`;
- reason about sampling, confidence intervals, hypothesis tests, and power;
- fit and interpret linear and quantile regression models with binary, categorical, and numeric predictors;
- distinguish additive from interaction models and marginal from conditional effects; and
- use `marginaleffects` for predictions, comparisons, slopes, and visualisations.

### Dataset and derived outcomes

The course uses `data/steps_clean.csv` throughout.

Binary-outcome chapters use the established Course 1 outcome:

```r
lsas_post_bin <- if_else(lsas_post < 50, "Low", "High")
```

Wednesday's multinomial chapter uses a three-category post-treatment LSAS severity outcome:

```r
lsas_post_severity <- case_when(
  lsas_post < 50 ~ "Low / no-to-mild",
  lsas_post < 80 ~ "Moderate / marked",
  TRUE ~ "Severe / very severe"
) |> factor(levels = c(
  "Low / no-to-mild",
  "Moderate / marked",
  "Severe / very severe"
))
```

The categories have 43, 79, and 47 non-missing observations, respectively. They collapse conventional descriptive severity bands for a stable teaching example. They must **not** be described as validated diagnostic or remission thresholds. Monday will distinguish this pedagogical categorisation from validated LSAS-SR screening cut-points (30 and 60) and a published remission cut-point (35).

Monday's chapter bibliography must cite the original screening and remission evidence: Mennin et al. (2002; [PMID 12405524](https://pubmed.ncbi.nlm.nih.gov/12405524/)); Rytwinski et al. (2009; [PMID 18781659](https://pubmed.ncbi.nlm.nih.gov/18781659/), [DOI 10.1002/da.20503](https://doi.org/10.1002/da.20503)); and Hoyer et al. (2018; [PMID 29430794](https://pubmed.ncbi.nlm.nih.gov/29430794/), [DOI 10.1002/cpp.2179](https://doi.org/10.1002/cpp.2179)).

### Course sequence

| Day | Chapter content | Lab content |
|---|---|---|
| Monday | Refresh the STePS workflow; motivate binary outcomes in clinical psychiatry; discuss the consequences of dichotomisation; define `lsas_post_bin`; introduce intercept-only and treatment models with `glm(..., family = binomial)`; explain probability, odds, log-odds, odds ratios, and uncertainty; contrast odds-ratio and probability-scale interpretations; estimate and plot probabilities. | A lightly under-specified PhD/academic scenario. Groups prepare a Quarto notebook that defines the outcome, reports prevalence and treatment-specific estimated probabilities with 95% CIs, makes one effect plot, and states the estimand and clinical interpretation. |
| Tuesday | **Binary predictor:** treatment restricted to waitlist versus therapist-guided. **Categorical predictor:** all three `trt` arms. Teach reference categories, category-specific predicted probabilities, and binary/pairwise probability differences. | Groups choose and justify a clinically relevant treatment contrast, then report probability-scale estimates, uncertainty, and a plot without treating log-odds coefficients as the final answer. |
| Wednesday | **Numeric predictor:** model `lsas_post_bin` using `gad_screen`, including probability curves and probability-scale slopes/effects. **Multinomial outcome:** reshape STePS data explicitly to participant-by-severity-category long format; fit a multinomial-logit model with `mlogit`; estimate and plot category probabilities by treatment. | Groups perform and document the long-format transformation, fit the multinomial model, plot category probabilities, and explain how a treatment contrast redistributes probability across outcome categories. |
| Thursday | Fit binary logistic models with `trt` and `phq_cat` (`phq9_screen < 10` versus `≥ 10`), first additively and then with an interaction. Explain conditional treatment effects on the probability scale. | Groups investigate whether a proposed "promising subgroup finding" survives probability-scale interpretation, uncertainty, and an interaction plot. |
| Friday | Fit binary logistic models with `trt`, continuous `phq9_screen`, and their interaction. Estimate and plot conditional treatment effects across baseline PHQ-9 values; distinguish conditional effects from a population-average contrast. | Groups evaluate an academically convenient but statistically questionable moderator claim, then communicate the conditional probability differences and uncertainty in a short, clinically intelligible conclusion. |

### Success criteria

Course 3 is complete when:

1. The Course 3 website contains the planned chapters and one lab per day, with navigation matching the approved course sequence.
2. Every chapter renders successfully using the project environment.
3. All binary models use `stats::glm()` with `family = binomial`, show probability-scale output with uncertainty as the primary result, and explain the associated odds ratio without equating it to a probability difference.
4. Wednesday explicitly teaches the required long-format transformation and successfully fits the agreed `mlogit` multinomial model.
5. `marginaleffects` is the common interpretation layer: every model has probability-scale estimates and at least one appropriate effect visualisation.
6. Every fitted model is followed immediately by a folded-by-default **Model interpretation** callout that translates the displayed result into a numerical, clinically meaningful effect: comparison/direction, absolute probability change in percentage points, 95% CI, and conditioning variables where relevant.
7. Every lab has a semi-open group Quarto task, an academically tongue-in-cheek PhD scenario, and required deliverables: estimand, model, uncertainty-aware visualisation, and plain-language clinical interpretation.
8. The course clearly distinguishes pedagogical LSAS categories from validated clinical screening/remission thresholds.

## Tech Stack

- Quarto website in `courses/course-3/`
- R project managed with `renv`
- R packages:
  - `tidyverse` for wrangling and plotting
  - `here` for project-relative data paths
  - `broom` for model summaries where useful
  - `marginaleffects` for predictions, contrasts, uncertainty, and plots
  - base R `stats::glm()` for binary logistic regression
  - `mlogit` for Wednesday's multinomial-logit model
- Dataset: `data/steps_clean.csv`

`mlogit` is an explicitly approved course dependency. No other new modelling packages are in scope unless approved first.

## Commands

Run from the repository root unless a command changes directory explicitly.

```bash
# Restore the locked R environment before rendering or linting.
Rscript -e 'renv::restore()'

# Preview Course 3 during authoring.
(cd courses/course-3 && quarto preview)

# Render Course 3 as the integration check for all executable R examples.
(cd courses/course-3 && quarto render)

# Lint Course 3 R and Quarto source files when lintr is available.
Rscript -e 'lintr::lint_dir("courses/course-3", exclusions = c("renv", "packrat"))'

# Inspect the R dependency state without changing the lockfile.
Rscript -e 'renv::status()'
```

## Project Structure

```text
courses/course-3/
├── _quarto.yml                         # Course navigation and Quarto settings
├── index.qmd                           # Course overview, lab process, learning outcomes
├── SPEC.md                             # Approved Course 3 specification
├── chapters/
│   ├── logistic-intro.qmd              # Monday: binary outcomes and logistic-regression foundations
│   ├── logistic-one-binary-predictor.qmd
│   ├── logistic-one-categorical-predictor.qmd
│   ├── logistic-one-numeric-predictor.qmd
│   ├── multinomial-logit.qmd           # Wednesday: long format and mlogit
│   ├── logistic-two-binary-predictors.qmd
│   └── logistic-binary-numeric-predictors.qmd
└── labs/
    ├── lab-logistic-foundations.qmd
    ├── lab-categorical-predictors.qmd
    ├── lab-multinomial-logit.qmd
    ├── lab-binary-interactions.qmd
    └── lab-continuous-interactions.qmd

data/
└── steps_clean.csv                     # Shared STePS analytic dataset
```

The placeholder chapter and lab files may be replaced only when their substantive replacement is ready. No data files should be copied into `courses/course-3/`.

## Code Style

Follow existing Course 2 conventions: readable R pipelines, one concept per labelled code chunk, descriptive object names, and model objects beginning with `mod_`. Use an explicit probability scale in `marginaleffects` calls and pair every model with an interpretation callout and a visualisation.

````qmd
```{r}
#| label: fit-treatment-logit
#| message: false
#| warning: false
mod_trt <- glm(
  lsas_post_bin ~ trt,
  family = binomial,
  data = df_binary
)

avg_predictions(mod_trt, by = "trt", type = "response")
```

::: {.callout-tip collapse="true"}
## Model interpretation

Compared with waitlist, therapist-guided treatment changes the estimated
probability of a low post-treatment LSAS score by **[estimate × 100] percentage
points** (95% CI **[lower × 100] to [upper × 100]**). State whether this is an
increase or decrease and, for adjusted/interaction models, name the values or
distribution of the variables on which the comparison is conditioned.

The probability difference is the primary treatment contrast. Also report the
associated odds ratio when useful for statistical literacy and explain that it
compares odds—not probabilities—and cannot be read as a percentage-point change.
:::

```{r}
#| label: plot-treatment-probabilities
plot_predictions(mod_trt, by = "trt", type = "response") +
  labs(
    x = "Treatment group",
    y = "Estimated probability of low post-treatment LSAS (95% CI)"
  ) +
  theme_minimal()
```
````

Style requirements:

- Define factor levels and reference categories explicitly.
- Make interval boundaries non-overlapping in code: `< 50`, `>= 50 & < 80`, `>= 80`.
- State what probability is being modelled and the direction of every contrast.
- In every Model interpretation callout, report the numerical effect in its natural unit: percentage points for probability differences, plus its 95% CI. For multinomial results, explain which category probability falls or rises and by how many percentage points.
- Use `plot_predictions()`, `plot_comparisons()`, or the appropriate probability plot after every fitted model.
- When reporting an odds ratio, name the comparison and explain it as a ratio of odds; pair it with the corresponding probability-scale result whenever a clinical interpretation is made.
- Keep humour in the lab scenario and prompts, never in statistical claims, data handling, or interpretation.
- Prefer model-derived probabilities and contrasts over manually transforming coefficients.

## Testing Strategy

Course materials are executable Quarto documents rather than a software package. Rendering is therefore the primary integration test.

| Concern | Verification |
|---|---|
| Executable examples and package availability | `(cd courses/course-3 && quarto render)` |
| Quarto navigation, cross-references, and HTML output | Inspect rendered Course 3 site after `quarto render` |
| R code style | `Rscript -e 'lintr::lint_dir("courses/course-3", exclusions = c("renv", "packrat"))'` |
| Derived binary and severity outcome definitions | Check category counts: binary threshold `<50`/`>=50`; severity groups 43/79/47 among non-missing outcomes |
| Long-format multinomial data | Verify one row per participant × severity alternative before fitting `mlogit`; verify category probabilities sum to one per prediction scenario |
| Probability-scale model interpretation | Review every model section for a folded Model interpretation callout that states the numerical percentage-point effect, its 95% CI, direction, and conditioning context; review the accompanying effect plot |
| Lab completeness | Review every lab against its deliverables: estimand, model, uncertainty-aware figure, and plain-language clinical conclusion |

## Boundaries

### Always

- Reuse `data/steps_clean.csv`, `data/steps_baseline.rds`, and the Course 1–2 STePS context unless the spec is updated first.
- Treat logistic regression as primarily inferential and interpret results on the probability scale; teach odds ratios as secondary literature-reading concepts.
- Put a folded Model interpretation callout directly below every fitted model; state the numerical result in percentage points, its 95% CI, direction, and conditioning context, and distinguish any odds ratio from that probability-scale result.
- Include model-effect visualisations frequently and label their probability scale and 95% CIs clearly.
- Define the LSAS derived outcomes and factor reference levels explicitly in each relevant chapter or shared setup.
- Render Course 3 after each completed chapter/lab slice and report any verification that could not run.
- Maintain semi-open, group-based Quarto labs with the agreed academic/PhD framing.

### Ask first

- Adding, removing, or changing R package dependencies beyond approved `mlogit`.
- Changing the STePS data source, clinical outcome definitions, predictor definitions, or LSAS category boundaries.
- Replacing `mlogit` with another multinomial fitting package.
- Changing the Quarto navigation, CI/publishing configuration, or generated-site conventions.
- Introducing new datasets, external APIs, or participant-level sensitive data.

### Never

- Present the 50/80 teaching categories as validated diagnostic or remission thresholds.
- Present odds ratios or log-odds coefficients as probability differences.
- Remove the long-format transformation from the multinomial lesson.
- Turn labs into fully prescriptive click-by-click tutorials.
- Fabricate clinical claims, citations, or validation evidence.
- Commit secrets, edit `renv.lock` incidentally, or overwrite the unrelated pre-existing `renv.lock` modification.

## Open Questions

1. Confirm that the `mlogit` + `marginaleffects` probability workflow renders and supports the required category-probability contrasts in the restored project environment before writing Wednesday's final examples.
2. Decide whether the final Course 3 website should retain placeholder files until each approved slice replaces them, or whether the navigation should be updated in one approved structural change.
