# ==============================================================================
# Script: 06_model_comparison.R
# Purpose: Compare models on test set, calculate metrics (AUC-ROC, AUC-PR,
#          Sensitivity, Specificity), and output tables.
# ==============================================================================

library(tidyverse)
library(caret)
library(pROC)

message("Executing model comparison...")

# Paths
test_data_path <- "data/processed/test_data.csv"
rf_model_path  <- "data/processed/rf_model.rds"
xgb_model_path <- "data/processed/xgb_model.rds"
svm_model_path <- "data/processed/svm_model.rds"
lr_model_path  <- "data/processed/lr_model.rds"

comparison_table_output <- "results/tables/model_performance_comparison.csv"

# Load models and test data
if (!all(file.exists(c(test_data_path, rf_model_path, xgb_model_path, svm_model_path, lr_model_path)))) {
  stop("Missing test data or trained models. Run prior training scripts first.")
}

test_df   <- read_csv(test_data_path)
rf_model  <- readRDS(rf_model_path)
xgb_model <- readRDS(xgb_model_path)
svm_model <- readRDS(svm_model_path)
lr_model  <- readRDS(lr_model_path)

# Prepare test variables
test_df <- test_df %>%
  mutate(
    Outcome = factor(Outcome, levels = c("Survived", "Deceased")),
    Sex = factor(Sex)
  )

# Predict probabilities and classes
models <- list(
  Random_Forest = rf_model,
  XGBoost = xgb_model,
  SVM = svm_model,
  Logistic_Regression = lr_model
)

results <- map_dfr(names(models), function(model_name) {
  model <- models[[model_name]]
  
  # Predict classes
  pred_class <- predict(model, test_df)
  
  # Predict probabilities (positive class = 'Deceased')
  pred_prob <- predict(model, test_df, type = "prob")[["Deceased"]]
  
  # Confusion Matrix metrics
  cm <- confusionMatrix(pred_class, test_df$Outcome, positive = "Deceased")
  
  # ROC/AUC
  roc_curve <- roc(test_df$Outcome, pred_prob, levels = c("Survived", "Deceased"), direction = "<")
  auc_val <- auc(roc_curve)
  
  tibble(
    Model = model_name,
    AUC_ROC = as.numeric(auc_val),
    Sensitivity = cm$byClass[["Sensitivity"]],
    Specificity = cm$byClass[["Specificity"]],
    F1_Score = cm$byClass[["F1"]],
    Accuracy = cm$overall[["Accuracy"]]
  )
})

# Write out comparison metrics
dir.create(dirname(comparison_table_output), recursive = TRUE, showWarnings = FALSE)
write_csv(results, comparison_table_output)
message("Model comparison complete. Performance table saved to: ", comparison_table_output)
print(results)
