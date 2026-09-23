# Implementation Plan: Course 3 — Regression Models for Binary and Categorical Outcomes

## Overview

Implement the approved Course 3 specification as a self-contained Quarto website under `courses/course-3/`. The course will add five day-specific labs and seven focused chapters, preserve the Course 2 STePS and `marginaleffects` workflow, and introduce `mlogit` only after an early compatibility check on the real data.

The ordered task details and checklists live in [`tasks/todo.md`](todo.md).

## Architecture Decisions

- **Course structure:** Build one independently renderable chapter/lab slice at a time. Monday has one chapter; Tuesday and Wednesday each have two short, focused chapters; Thursday and Friday each have one. Every slice is added to the Quarto sidebar only when its source files exist.
- **Data and outcomes:** Use `data/steps_clean.csv` as the common analytic dataset. Each chapter explicitly derives the agreed binary and, where relevant, three-level LSAS outcomes so a notebook can be read and run independently.
- **Interpretation layer:** Use `marginaleffects` as the standard interface for probability-scale estimates, contrasts, uncertainty, and plots. Odds ratios are included as secondary literature-reading estimates and explicitly distinguished from probability differences.
- **Model interpretation pattern:** Every fitted model is followed directly by a collapsed Quarto callout reporting the comparison, numerical probability difference in percentage points, 95% CI, direction, and conditioning context. For multinomial models, the callout explains the probability redistribution across severity categories.
- **Multinomial risk-first approach:** Do not start Wednesday source materials until the real STePS data can be converted to the required `mlogit` long form and `marginaleffects` can return category probabilities with uncertainty. If the confirmed workflow is not supported, stop and ask the user; do not silently substitute another modelling package.
- **Labs:** Each lab stays intentionally semi-open. Its scenario supplies the dry academic/PhD framing; its required deliverables remain statistical and concrete: estimand, model, uncertainty-aware effect plot, and plain-language clinical conclusion.
- **Navigation and placeholders:** Update `_quarto.yml` incrementally with each completed day. Remove the existing placeholder entries only after their substantive replacements are present, preventing broken navigation during incremental rendering.

## Dependency Graph

```text
Approved SPEC.md
    │
    ├── Task 1: mlogit + marginaleffects feasibility and dependency state
    │       │
    │       └── Task 4: Wednesday numeric and multinomial material
    │
    └── Task 2: Monday foundation + course navigation/index
            │
            ├── Task 3: Tuesday predictor chapters + lab
            │       │
            ├── Task 5: Thursday binary interaction chapter + lab
            │       └── Task 6: Friday continuous-interaction chapter + lab
            │
            └── Task 4: Wednesday material

Tasks 3–6 share `_quarto.yml`; implement them sequentially.
Task 7 performs final navigation cleanup and whole-course verification after Tasks 2–6.
```

## Task List

### Phase 1: Validate the high-risk workflow and build the foundation

- [x] **Task 1:** Validate the `mlogit` + `marginaleffects` workflow on real STePS data. See [`tasks/todo.md`](todo.md#task-1-validate-the-multinomial-workflow) for acceptance criteria.
- [x] **Task 2:** Implement Monday's logistic-regression foundation, first lab, course overview, and initial navigation. See [`tasks/todo.md`](todo.md#task-2-implement-monday-foundation-and-course-entry-points).
- [x] **Task 3:** Implement Tuesday's binary/categorical-predictor chapters and lab. See [`tasks/todo.md`](todo.md#task-3-implement-tuesdays-predictor-models-and-lab).

### Checkpoint: Foundation

- [ ] The restored environment can run the required binary and multinomial modelling workflows.
- [ ] Monday and Tuesday render without errors.
- [ ] Every completed model has a collapsed numerical interpretation callout and a probability-scale effect plot.
- [ ] Review the rendered foundation material with the human before proceeding.

### Phase 2: Complete the core modelling sequence

- [x] **Task 4:** Implement Wednesday's numeric-predictor and multinomial-logit chapters and lab. See [`tasks/todo.md`](todo.md#task-4-implement-wednesdays-numeric-and-multinomial-material).
- [x] **Task 5:** Implement Thursday's two-binary-predictor interaction chapter and lab. See [`tasks/todo.md`](todo.md#task-5-implement-thursdays-binary-interaction-material).
- [x] **Task 6:** Implement Friday's binary-by-continuous interaction chapter and lab. See [`tasks/todo.md`](todo.md#task-6-implement-fridays-continuous-interaction-material).

### Checkpoint: Core course

- [ ] All five days render successfully.
- [ ] Wednesday visibly teaches the long-format transformation and category-probability interpretation.
- [ ] The course sequence, navigational order, and lab framing match the approved specification.
- [ ] Review the rendered full course with the human before final cleanup.

### Phase 3: Finalise and verify

- [x] **Task 7:** Remove placeholders, perform whole-course quality checks, and verify source/citation requirements. See [`tasks/todo.md`](todo.md#task-7-finalise-navigation-and-run-whole-course-quality-checks).

### Checkpoint: Complete

- [ ] `quarto render` succeeds for Course 3.
- [ ] `lintr::lint_dir("courses/course-3")` succeeds or all exceptions are documented and approved.
- [ ] Every Course 3 success criterion in `courses/course-3/SPEC.md` is checked against the rendered site.
- [ ] Ready for human review and merge.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| `mlogit` requires a long discrete-choice representation and has a more constrained `marginaleffects` interface than ordinary `glm` | High | Run Task 1 first using real STePS data. Require successful probability estimates with uncertainty before authoring Wednesday. Escalate rather than substituting a package. |
| `mlogit` is not currently a direct package entry in `renv.lock`, while `renv.lock` has a large unrelated uncommitted modification | High | Inspect and preserve the existing diff. Do not alter the lockfile until its owner/work is reconciled; use an isolated validation environment or explicit user approval for any lockfile resolution. |
| LSAS 50/80 categories could be misrepresented as clinical validation cut-points | High | Include the required screening/remission citations Monday and label the 50/80 grouping as a pedagogical severity categorisation in every relevant chapter. |
| Odds ratios are misread as probability changes | High | Pair every clinically interpreted odds ratio with a probability-scale estimate; use the required numerical callout pattern and effect plot. |
| Partially updated navigation links to missing chapters | Medium | Update `_quarto.yml` only in the task that adds its linked source files; retain placeholders until replacements exist. |
| Semi-open labs become either vague or overly prescriptive | Medium | Require four deliverables while leaving the modelling route and narrative detail open. Review at each checkpoint. |
| Rendering changes generated website output outside the intended source change | Medium | Review `git status` after every render; follow project conventions for generated files and do not commit unrelated outputs. |

## Open Questions

1. Who owns the current uncommitted `renv.lock` update, and should its change be committed/reverted before `mlogit` becomes a direct locked dependency?
2. Does the validated `mlogit` workflow support all intended category-probability contrasts with the installed `marginaleffects` version, or does the specification need an approved adjustment?
3. Should the Course 3 site be published only after all five days are complete, or may completed slices be rendered/published incrementally?
