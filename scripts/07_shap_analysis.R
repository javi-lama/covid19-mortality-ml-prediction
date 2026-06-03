# ==============================================================================
# Script: 07_shap_analysis.R
# Purpose: Compute SHAP values for tree-based models to extract global 
#          feature importance and local patient explanations.
# ==============================================================================

library(tidyverse)
library(caret)
library(fastshap)

message("Executing SHAP interpretability analysis...")

# Paths
train_data_path <- "data/processed/train_data.csv"
rf_model_path   <- "data/processed/rf_model.rds"
shap_values_output <- "data/processed/shap_values.rds"

# Load model and data
if (!file.exists(train_data_path) || !file.exists(rf_model_path)) {
  stop("Missing training data or Random Forest model.")
}

train_df <- read_csv(train_data_path)
rf_model <- readRDS(rf_model_path)

# Prepare predictor matrix
predictors <- c("Age", "Sex", "Diabetes", "Hypertension", "Cardiovascular", "CRP", "D_Dimer", "LDH", "Lymphocytes")
X <- train_df[, predictors]
X$Sex <- as.numeric(factor(X$Sex)) # convert factor to numeric for SHAP calculations

# Prediction wrapper for fastshap
p_fun <- function(object, newdata) {
  # convert factor variables back if needed in the prediction function
  # Here we just predict probability of "Deceased"
  predict(object, newdata = newdata, type = "prob")[["Deceased"]]
}

# Calculate SHAP values
message("Computing SHAP values (this may take a few minutes)...")
set.seed(321)
shap_explanations <- explain(
  rf_model,
  X = as.matrix(X),
  pred_wrapper = p_fun,
  nsim = 20, # Monte Carlo simulations for kernel/exact estimates
  adjust = TRUE
)

# Save SHAP computations
saveRDS(shap_explanations, shap_values_output)
message("SHAP values successfully computed and saved to: ", shap_values_output)
