# Validation prototype for Course 3 Task 1.
#
# Run with:
# rig run --r-version 4.5-arm64 --script tasks/validate-mlogit-workflow.R

library(dplyr)
library(tidyr)
library(mlogit)
library(marginaleffects)

steps <- read.csv2("data/steps_clean.csv") |>
  filter(!is.na(lsas_post), !is.na(trt)) |>
  mutate(
    severity_observed = case_when(
      lsas_post < 50 ~ "low_no_to_mild",
      lsas_post < 80 ~ "moderate_marked",
      TRUE ~ "severe_very_severe"
    ),
    severity_observed = factor(
      severity_observed,
      levels = c(
        "low_no_to_mild",
        "moderate_marked",
        "severe_very_severe"
      )
    ),
    trt = factor(
      trt,
      levels = c("waitlist", "therapist-guided", "self-guided")
    )
  ) |>
  select(id, trt, severity_observed)

long <- crossing(
  steps,
  severity_alt = levels(steps$severity_observed)
) |>
  mutate(choice = severity_alt == severity_observed)

stopifnot(nrow(long) == 3L * nrow(steps))
stopifnot(all(table(long$id) == 3L))
stopifnot(all(tapply(long$choice, long$id, sum) == 1L))

mlogit_data <- mlogit.data(
  long,
  choice = "choice",
  shape = "long",
  chid.var = "id",
  alt.var = "severity_alt",
  drop.index = TRUE
)

mod_multinomial <- mlogit(
  choice ~ 1 | trt,
  data = mlogit_data,
  reflevel = "low_no_to_mild"
)

# Supply the ordinary long data frame explicitly. Passing the mlogit.data
# object itself does not allow marginaleffects to recover the required data.
probabilities <- avg_predictions(
  mod_multinomial,
  newdata = as.data.frame(long),
  by = "trt"
) |>
  as.data.frame()

probability_sums <- probabilities |>
  summarize(total_probability = sum(estimate), .by = trt)

stopifnot(nrow(probabilities) == 9L)
stopifnot(all(abs(probability_sums$total_probability - 1) < 1e-10))
stopifnot(all(is.finite(probabilities$conf.low)))
stopifnot(all(is.finite(probabilities$conf.high)))

therapist_minus_waitlist <- function(x) {
  x |>
    group_by(group, trt) |>
    summarize(estimate = mean(estimate), .groups = "drop") |>
    pivot_wider(names_from = trt, values_from = estimate) |>
    transmute(
      term = group,
      estimate = `therapist-guided` - waitlist
    )
}

probability_differences <- predictions(
  mod_multinomial,
  newdata = as.data.frame(long),
  hypothesis = therapist_minus_waitlist
) |>
  as.data.frame()

stopifnot(nrow(probability_differences) == 3L)
stopifnot(all(is.finite(probability_differences$conf.low)))
stopifnot(all(is.finite(probability_differences$conf.high)))

cat("Validated mlogit + marginaleffects workflow.\n\n")
print(probabilities)
cat("\nTherapist-guided minus waitlist probability differences:\n")
print(probability_differences)
