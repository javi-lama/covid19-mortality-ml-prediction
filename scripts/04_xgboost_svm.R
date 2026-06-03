# ==============================================================================
# Script: 04_xgboost_svm.R
# Purpose: Train and tune XGBoost and Support Vector Machine (SVM) classifiers.
# ==============================================================================

library(tidyverse)
library(caret)
library(xgboost)
library(e1071)

message("Executing XGBoost and SVM training...")

# Paths
train_data_path <- "data/processed/train_data.csv"
xgb_model_output <- "data/processed/xgb_model.rds"
svm_model_output <- "data/processed/svm_model.rds"

# Load training data
if (!file.exists(train_data_path)) {
  stop("Training data not found. Please run scripts/02_preprocessing.R.")
}
train_df <- read_csv(train_data_path)

# Prepare variables
train_df <- train_df %>%
  mutate(
    Outcome = factor(Outcome, levels = c("Survived", "Deceased")),
    Sex = factor(Sex)
  )

# Define feature columns
predictors <- c("Age", "Sex", "Diabetes", "Hypertension", "Cardiovascular", "CRP", "D_Dimer", "LDH", "Lymphocytes")

# Train Control
control <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  savePredictions = "final"
)

# -----------------
# 1. XGBoost Tuning
# -----------------
xgb_grid <- expand.grid(
  nrounds = c(50, 100),
  max_depth = c(3, 6),
  eta = c(0.01, 0.1),
  gamma = 0,
  colsample_bytree = 0.8,
  min_child_weight = 1,
  subsample = 0.8
)

set.seed(789)
xgb_model <- train(
  x = train_df[, predictors],
  y = train_df$Outcome,
  method = "xgbTree",
  metric = "ROC",
  trControl = control,
  tuneGrid = xgb_grid,
  verbose = FALSE
)

saveRDS(xgb_model, xgb_model_output)
message("XGBoost model saved to: ", xgb_model_output)

# ------------
# 2. SVM Tuning
# ------------
svm_grid <- expand.grid(
  sigma = c(0.01, 0.1),
  C = c(1, 10)
)

set.seed(789)
svm_model <- train(
  x = train_df[, predictors],
  y = train_df$Outcome,
  method = "svmRadial",
  metric = "ROC",
  trControl = control,
  tuneGrid = svm_grid
)

saveRDS(svm_model, svm_model_output)
message("SVM model saved to: ", svm_model_output)
