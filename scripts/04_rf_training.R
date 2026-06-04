# ==============================================================================
# Script: 03_rf_training.R
# Purpose: Train and hyperparameter-tune a Random Forest classifier.
# ==============================================================================

library(tidyverse)
library(caret)
library(randomForest)

message("Executing Random Forest training...")

# Paths
train_data_path <- "data/processed/train_data.csv"
model_output_path <- "data/processed/rf_model.rds"

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

# Train Random Forest using Caret cross-validation
control <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  savePredictions = "final"
)

tuning_grid <- expand.grid(.mtry = c(2, 3, 4, 5))

set.seed(456)
rf_model <- train(
  x = train_df[, predictors],
  y = train_df$Outcome,
  method = "rf",
  metric = "ROC",
  trControl = control,
  tuneGrid = tuning_grid,
  ntree = 500
)

# Save the trained model
saveRDS(rf_model, model_output_path)
message("Random Forest model trained and saved to: ", model_output_path)
print(rf_model)
