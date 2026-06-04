# ==============================================================================
# Script: 05_logistic_regression.R
# Purpose: Train a baseline Logistic Regression model for comparison.
# ==============================================================================

library(tidyverse)
library(caret)

message("Executing Logistic Regression baseline training...")

# Paths
train_data_path <- "data/processed/train_data.csv"
lr_model_output <- "data/processed/lr_model.rds"

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

# Train GLM (Logistic Regression)
set.seed(111)
lr_model <- train(
  x = train_df[, predictors],
  y = train_df$Outcome,
  method = "glm",
  family = "binomial",
  metric = "ROC",
  trControl = control
)

saveRDS(lr_model, lr_model_output)
message("Logistic Regression baseline saved to: ", lr_model_output)
summary(lr_model$finalModel)
