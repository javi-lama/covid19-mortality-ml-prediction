# ==============================================================================
# Script: 09_calibration.R
# Purpose: Evaluate probability calibration using calibration curves, Hosmer-Lemeshow
#          goodness-of-fit tests, and Brier scores.
# ==============================================================================

library(tidyverse)
library(caret)
library(ResourceSelection)

message("Executing probability calibration evaluation...")

# Paths
test_data_path <- "data/processed/test_data.csv"
rf_model_path  <- "data/processed/rf_model.rds"
calibration_results_output <- "results/tables/calibration_metrics.csv"

# Load data and model
if (!file.exists(test_data_path) || !file.exists(rf_model_path)) {
  stop("Missing test dataset or Random Forest model.")
}

test_df  <- read_csv(test_data_path) %>%
  mutate(Outcome = factor(Outcome, levels = c("Survived", "Deceased")), Sex = factor(Sex))
rf_model <- readRDS(rf_model_path)

# Predict probabilities
pred_probs <- predict(rf_model, test_df, type = "prob")[["Deceased"]]
actuals    <- as.numeric(test_df$Outcome == "Deceased")

# 1. Brier Score
brier_score <- mean((pred_probs - actuals)^2)

# 2. Hosmer-Lemeshow Test
hl_test <- hoslem.test(actuals, pred_probs, g = 10)

# 3. Save calibration metrics
metrics_df <- tibble(
  Brier_Score = brier_score,
  HL_Statistic = hl_test$statistic,
  HL_p_value = hl_test$p.value
)

dir.create(dirname(calibration_results_output), recursive = TRUE, showWarnings = FALSE)
write_csv(metrics_df, calibration_results_output)
message("Calibration metrics saved to: ", calibration_results_output)
print(metrics_df)
