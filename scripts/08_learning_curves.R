# ==============================================================================
# Script: 08_learning_curves.R
# Purpose: Generate learning curves by evaluating model performance at different
#          training sample sizes (diagnoses underfitting/overfitting).
# ==============================================================================

library(tidyverse)
library(caret)
library(pROC)

message("Generating learning curves...")

# Paths
train_data_path <- "data/processed/train_data.csv"
test_data_path  <- "data/processed/test_data.csv"
learning_curves_output <- "results/tables/learning_curve_data.csv"

# Load data
if (!file.exists(train_data_path) || !file.exists(test_data_path)) {
  stop("Missing train or test datasets. Run preprocessing first.")
}

train_df <- read_csv(train_data_path) %>%
  mutate(Outcome = factor(Outcome, levels = c("Survived", "Deceased")), Sex = factor(Sex))
test_df  <- read_csv(test_data_path) %>%
  mutate(Outcome = factor(Outcome, levels = c("Survived", "Deceased")), Sex = factor(Sex))

predictors <- c("Age", "Sex", "Diabetes", "Hypertension", "Cardiovascular", "CRP", "D_Dimer", "LDH", "Lymphocytes")

# Sample sizes to evaluate (from 10% to 100% of the training set)
sample_fractions <- seq(0.1, 1.0, by = 0.1)
results <- list()

set.seed(444)
for (frac in sample_fractions) {
  sample_size <- round(frac * nrow(train_df))
  message(" - Training on ", sample_size, " observations (", frac * 100, "%)...")
  
  # Subsample training data
  sub_indices <- sample(seq_len(nrow(train_df)), size = sample_size)
  sub_train <- train_df[sub_indices, ]
  
  # Train a standard classifier (e.g., Logistic Regression or simple RF for speed)
  fit_control <- trainControl(method = "none", classProbs = TRUE)
  fit <- train(
    x = sub_train[, predictors],
    y = sub_train$Outcome,
    method = "glm",
    family = "binomial",
    trControl = fit_control
  )
  
  # Evaluate on training subsample
  train_preds <- predict(fit, sub_train, type = "prob")[["Deceased"]]
  train_auc   <- as.numeric(auc(roc(sub_train$Outcome, train_preds, levels = c("Survived", "Deceased"), quiet = TRUE)))
  
  # Evaluate on test set
  test_preds  <- predict(fit, test_df, type = "prob")[["Deceased"]]
  test_auc    <- as.numeric(auc(roc(test_df$Outcome, test_preds, levels = c("Survived", "Deceased"), quiet = TRUE)))
  
  results[[as.character(frac)]] <- tibble(
    Fraction = frac,
    SampleSize = sample_size,
    Train_AUC = train_auc,
    Test_AUC = test_auc
  )
}

learning_curve_df <- bind_rows(results)

# Save learning curve data
dir.create(dirname(learning_curves_output), recursive = TRUE, showWarnings = FALSE)
write_csv(learning_curve_df, learning_curves_output)
message("Learning curve data successfully written to: ", learning_curves_output)
print(learning_curve_df)
