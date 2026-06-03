# ==============================================================================
# Script: 00_setup.R
# Purpose: Initialize the analytical environment and install/load dependencies.
# ==============================================================================

message("Starting environment setup...")

# Define required packages
required_packages <- c(
  "tidyverse",      # Data manipulation and visualization
  "caret",          # Machine learning framework (preprocessing, tuning)
  "randomForest",   # Random Forest model implementation
  "xgboost",        # Gradient boosted trees
  "e1071",          # Support Vector Machine (SVM) kernel methods
  "pROC",           # ROC curve plotting and AUC calculation
  "shapr",          # SHAP values for model interpretability
  "fastshap",       # Alternative fast SHAP implementation
  "ResourceSelection", # Hosmer-Lemeshow calibration tests
  "gridExtra",      # Multi-panel plots
  "openxlsx"        # Reading/writing Excel files for checklists
)

# Function to check, install, and load packages
setup_packages <- function(packages) {
  missing_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  
  if (length(missing_packages) > 0) {
    message("Installing missing packages: ", paste(missing_packages, collapse = ", "))
    install.packages(missing_packages, dependencies = TRUE)
  } else {
    message("All required packages are already installed.")
  }
  
  # Load packages
  message("Loading packages...")
  invisible(lapply(packages, library, character.only = TRUE))
}

# Run setup
setup_packages(required_packages)

message("Environment setup completed successfully.")
