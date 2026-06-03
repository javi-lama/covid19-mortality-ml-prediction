# ==============================================================================
# Script: 02_preprocessing.R
# Purpose: Handle missing data, scale/normalize features, perform split
#          (Train/Test), and prepare data structures for model training.
# ==============================================================================

library(tidyverse)
library(caret)

message("Executing preprocessing pipeline...")

# Paths
cleaned_data_path <- "data/processed/cleaned_covid_data.csv"
train_data_output <- "data/processed/train_data.csv"
test_data_output <- "data/processed/test_data.csv"

# Load cleaned data
if (!file.exists(cleaned_data_path)) {
  stop("Cleaned data not found at '", cleaned_data_path, "'. Please run scripts/01_data_cleaning.R first.")
}

df <- read_csv(cleaned_data_path)

# Handle Missing Values (e.g., via median/K-Nearest Neighbors imputation)
# Using caret's preProcess to impute missing predictor values
impute_model <- preProcess(as.data.frame(df), method = c("medianImpute"))
df_imputed <- predict(impute_model, as.data.frame(df)) %>% as_tibble()

# Split into Train (80%) and Test (20%) sets
set.seed(123)
train_indices <- createDataPartition(df_imputed$Outcome, p = 0.8, list = FALSE)

train_set <- df_imputed[train_indices, ]
test_set  <- df_imputed[-train_indices, ]

# Save preprocessed partitions
write_csv(train_set, train_data_output)
write_csv(test_set, test_data_output)

message("Preprocessing completed:")
message(" - Training observations: ", nrow(train_set))
message(" - Testing observations: ", nrow(test_set))
message(" - Training partition saved to: ", train_data_output)
message(" - Testing partition saved to: ", test_data_output)
