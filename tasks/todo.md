# Course 3 Task List

Source of truth: [`courses/course-3/SPEC.md`](../courses/course-3/SPEC.md)

Implementation plan: [`tasks/plan.md`](plan.md)

## Task 1: Validate the multinomial workflow

**Description:** Validate the approved `mlogit` approach before writing Wednesday's material. Use the real STePS data to create the agreed three-category severity outcome, reshape to one participant-by-category row per alternative, fit an `mlogit` model, and verify the supported `marginaleffects` probability workflow. Protect the unrelated pre-existing `renv.lock` modification throughout.

**Acceptance criteria:**
- [x] The environment state and existing `renv.lock` diff are inspected before any package-resolution action.
- [x] A reproducible, actual-data prototype successfully creates the `<50` / `50–79` / `≥80` severity outcome and the required long format.
- [x] The prototype fits the approved `mlogit` model and returns category probabilities with uncertainty through `marginaleffects`.
- [x] Predicted category probabilities sum to one within each prediction scenario.
- [x] The required probability contrasts are supported; the prototype estimates therapist-guided minus waitlist probability differences for all three severity categories.

**Verification:**
- [x] Run the prototype in the restored R 4.5.1 environment: `rig run --r-version 4.5-arm64 --script tasks/validate-mlogit-workflow.R`.
- [x] Inspect the long data: one row per participant × severity alternative.
- [x] Inspect category-probability output and its confidence intervals manually.
- [x] Run `rig run --r-version 4.5-arm64 -e 'renv::status()'` and review `git diff -- renv.lock`.

**Result:** Passed. `marginaleffects` must receive `newdata = as.data.frame(long)`, not the `mlogit.data` object. The prototype validates category probabilities, their 95% CIs, probability sums of one within treatment, and therapist-guided-minus-waitlist probability differences.

**Dependencies:** None

**Files likely touched:**
- `renv.lock` only if its existing unrelated change is reconciled and the user explicitly approves a direct dependency update; otherwise no tracked source file.
- A temporary, untracked validation script or an approved permanent example file, if needed.

**Estimated scope:** Small (1–2 files)

## Task 2: Implement Monday foundation and course entry points

**Description:** Replace the Course 3 overview and placeholder navigation with the first vertical slice: the logistic-regression foundation chapter and its semi-open lab. Establish the shared outcome definitions, probability-first/odds-ratio-secondary teaching pattern, original LSAS citations, folded numerical interpretation callouts, and effect plots.

**Acceptance criteria:**
- [ ] `index.qmd` explains the course purpose, intended learning outcomes, lab workflow, and responsible AI use consistently with earlier courses.
- [ ] `logistic-intro.qmd` defines both LSAS outcomes, separates pedagogical 50/80 categories from validated 30/60 screening and 35 remission thresholds, and cites the specified LSAS papers.
- [ ] The chapter fits intercept-only and treatment binary logistic models; every model has a folded callout with numerical percentage-point interpretation, 95% CI, and odds-ratio distinction.
- [ ] The chapter includes probability-scale `marginaleffects` plots.
- [ ] The lab provides a semi-open PhD/academic scenario and requires an estimand, model, effect figure, and clinical conclusion.
- [ ] `_quarto.yml` links only to source files that exist.

**Verification:**
- [ ] Run `(cd courses/course-3 && quarto render)`.
- [ ] Check rendered citations, collapsed callouts, tables, and plots manually.
- [ ] Run `Rscript -e 'lintr::lint_dir("courses/course-3")'`.

**Dependencies:** Task 1 may run in parallel, but Task 2 must complete before Tasks 3–6 update shared navigation.

**Files likely touched:**
- `courses/course-3/_quarto.yml`
- `courses/course-3/index.qmd`
- `courses/course-3/chapters/logistic-intro.qmd`
- `courses/course-3/labs/lab-logistic-foundations.qmd`

**Estimated scope:** Medium (4 files)

## Task 3: Implement Tuesday’s predictor models and lab

**Description:** Add the binary-predictor and three-level categorical-predictor logistic chapters using treatment as the common clinical example. Add Tuesday's semi-open lab and navigation entries.

**Acceptance criteria:**
- [ ] The binary-predictor chapter uses waitlist versus therapist-guided treatment with explicit factor levels and a probability difference with 95% CI.
- [ ] The categorical-predictor chapter uses all three treatment arms, explicit reference coding, category-specific probabilities, and clinically meaningful pairwise probability differences.
- [ ] Both chapters present odds ratios only as secondary literature-reading estimates and pair them with probability-scale interpretations and effect plots.
- [ ] Tuesday's lab includes the agreed semi-open deliverables and academic/PhD framing.
- [ ] Navigation exposes the two completed chapters and the lab in Tuesday order.

**Verification:**
- [ ] Run `(cd courses/course-3 && quarto render)`.
- [ ] Manually verify contrast directions, percentage-point callouts, 95% CIs, and plots.
- [ ] Run `Rscript -e 'lintr::lint_dir("courses/course-3")'`.

**Dependencies:** Task 2

**Files likely touched:**
- `courses/course-3/_quarto.yml`
- `courses/course-3/chapters/logistic-one-binary-predictor.qmd`
- `courses/course-3/chapters/logistic-one-categorical-predictor.qmd`
- `courses/course-3/labs/lab-categorical-predictors.qmd`

**Estimated scope:** Medium (4 files)

## Checkpoint: Foundation

- [ ] Tasks 1–3 meet their acceptance criteria.
- [ ] Restore/render/lint commands have been attempted and their results recorded.
- [ ] Monday and Tuesday meet the approved interpretation-callout and plotting standards.
- [ ] Human reviews rendered foundation material before implementation continues.

## Task 4: Implement Wednesday’s numeric and multinomial material

**Description:** Add the binary logistic regression chapter with a numeric predictor and the multinomial-logit chapter that explicitly teaches long-format conversion, `mlogit`, category probabilities, and probability redistribution. Add Wednesday's lab and navigation entries.

**Acceptance criteria:**
- [ ] The numeric-predictor chapter models `lsas_post_bin` using `gad_screen`, with a probability curve, uncertainty, and probability-scale effect interpretation.
- [ ] The multinomial chapter creates the agreed LSAS severity factor, visibly transforms the data to long format, and explains why that representation is required by `mlogit`.
- [ ] The multinomial model uses the Task 1-validated workflow and produces category probabilities with 95% CIs by treatment.
- [ ] The multinomial interpretation identifies the numerical percentage-point increase/decrease in each category probability and does not mislabel the 50/80 bands as validated thresholds.
- [ ] Wednesday's lab requires students to document the reshape, model, category-probability plot, and probability-redistribution interpretation.

**Verification:**
- [ ] Run `(cd courses/course-3 && quarto render)`.
- [ ] Check that every participant has the expected alternative rows before fitting the multinomial model.
- [ ] Check that predicted category probabilities sum to one for each scenario.
- [ ] Run `Rscript -e 'lintr::lint_dir("courses/course-3")'`.

**Dependencies:** Tasks 1 and 2

**Files likely touched:**
- `courses/course-3/_quarto.yml`
- `courses/course-3/chapters/logistic-one-numeric-predictor.qmd`
- `courses/course-3/chapters/multinomial-logit.qmd`
- `courses/course-3/labs/lab-multinomial-logit.qmd`

**Estimated scope:** Medium (4 files)

## Task 5: Implement Thursday’s binary-interaction material

**Description:** Add the two-binary-predictor chapter and lab. Students compare additive and interaction logistic models for treatment and baseline depression category, then interpret conditional treatment probability differences.

**Acceptance criteria:**
- [ ] `phq_cat` is explicitly derived as `phq9_screen < 10` versus `≥ 10`.
- [ ] The chapter fits additive and interaction models for `trt * phq_cat` with explicit reference levels.
- [ ] Callouts distinguish the interaction coefficient/odds ratio from conditional treatment probability differences in percentage points with 95% CIs.
- [ ] Plots make the additive-versus-interaction distinction visible on the probability scale.
- [ ] The lab scenario asks students to assess a subgroup claim using an interaction plot and uncertainty-aware interpretation.

**Verification:**
- [ ] Run `(cd courses/course-3 && quarto render)`.
- [ ] Manually inspect conditional contrasts by `phq_cat`, effect-plot labels, and callouts.
- [ ] Run `Rscript -e 'lintr::lint_dir("courses/course-3")'`.

**Dependencies:** Task 2

**Files likely touched:**
- `courses/course-3/_quarto.yml`
- `courses/course-3/chapters/logistic-two-binary-predictors.qmd`
- `courses/course-3/labs/lab-binary-interactions.qmd`

**Estimated scope:** Medium (3 files)

## Task 6: Implement Friday’s continuous-interaction material

**Description:** Add the treatment-by-continuous-PHQ-9 chapter and lab. Students estimate, visualise, and communicate conditional treatment probability differences across the observed PHQ-9 range and contrast them with a population-average result.

**Acceptance criteria:**
- [ ] The chapter fits additive and interaction models for `trt * phq9_screen` with explicit reference coding.
- [ ] It reports conditional treatment probability differences at meaningful PHQ-9 values and as a curve, each with 95% CIs.
- [ ] It clearly distinguishes conditional effects, marginal/population-average contrasts, odds ratios, and probability differences.
- [ ] The lab applies the same workflow to a deliberately academically convenient moderator claim and requires a clinically intelligible conclusion.
- [ ] Navigation exposes Friday's chapter and lab in the final course order.

**Verification:**
- [ ] Run `(cd courses/course-3 && quarto render)`.
- [ ] Manually inspect selected-value contrasts, conditional-effect plot, marginal contrast, and numerical callouts.
- [ ] Run `Rscript -e 'lintr::lint_dir("courses/course-3")'`.

**Dependencies:** Task 2

**Files likely touched:**
- `courses/course-3/_quarto.yml`
- `courses/course-3/chapters/logistic-binary-numeric-predictors.qmd`
- `courses/course-3/labs/lab-continuous-interactions.qmd`

**Estimated scope:** Medium (3 files)

## Checkpoint: Core course

- [ ] Tasks 4–6 meet their acceptance criteria.
- [ ] All five days render together.
- [ ] The model-effect visuals and interpretation callouts are consistent across days.
- [ ] Human reviews the rendered full course before finalisation.

## Task 7: Finalise navigation and run whole-course quality checks

**Description:** Remove placeholders once every substantive replacement exists. Audit the rendered course against every success criterion in the approved spec, ensure source links/citations work, and leave the working tree free of unintended generated files.

**Acceptance criteria:**
- [ ] No placeholder course entry is visible in the rendered sidebar or site.
- [ ] Course navigation order is Monday through Friday and all links resolve.
- [ ] The Monday LSAS evidence citations resolve and the severity-category disclaimer is present.
- [ ] Every model chapter contains required numerical callouts and probability-scale visualisations.
- [ ] Rendered output and the final diff contain no unrelated files, including the pre-existing `renv.lock` modification unless separately resolved.

**Verification:**
- [ ] Run `(cd courses/course-3 && quarto render)`.
- [ ] Run `Rscript -e 'lintr::lint_dir("courses/course-3")'`.
- [ ] Run `git diff --check` and inspect `git status --short`.
- [ ] Manually click all Course 3 sidebar links and inspect at least one callout/plot per chapter and lab.

**Dependencies:** Tasks 2–6

**Files likely touched:**
- `courses/course-3/_quarto.yml`
- `courses/course-3/chapters/template.qmd` (remove only if no longer needed)
- `courses/course-3/labs/template.qmd` (remove only if no longer needed)

**Estimated scope:** Small (1–3 files)
