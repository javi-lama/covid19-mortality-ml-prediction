# ==============================================================================
# Script: 01_data_cleaning.R
# Purpose: Clean raw clinical dataset, handle obvious out-of-range values,
#          and format variables for preprocessing.
# ==============================================================================

library(tidyverse)

message("Executing data cleaning pipeline...")

# Paths
raw_data_path <- "data/raw_covid_data.csv" # Update to actual file path
cleaned_data_output <- "data/processed/cleaned_covid_data.csv"

# Check if raw data exists
if (!file.exists(raw_data_path)) {
  warning("Raw data file '", raw_data_path, "' not found. Using simulated data as placeholder.")
  
  # Generate simulated raw data for template execution
  set.seed(42)
  n <- 500
  simulated_data <- tibble(
    Patient_ID = 1:n,
    Age = round(rnorm(n, mean = 62, sd = 15)),
    Sex = sample(c("Male", "Female"), n, replace = TRUE, prob = c(0.55, 0.45)),
    Diabetes = sample(c(0, 1), n, replace = TRUE, prob = c(0.8, 0.2)),
    Hypertension = sample(c(0, 1), n, replace = TRUE, prob = c(0.7, 0.3)),
    Cardiovascular = sample(c(0, 1), n, replace = TRUE, prob = c(0.9, 0.1)),
    CRP = round(pmax(0.1, rnorm(n, mean = 45, sd = 30)), 2),
    D_Dimer = round(pmax(0.05, rnorm(n, mean = 1.2, sd = 1.5)), 2),
    LDH = round(pmax(50, rnorm(n, mean = 350, sd = 120))),
    Lymphocytes = round(pmax(0.1, rnorm(n, mean = 1.1, sd = 0.6)), 2),
    ICU_Admission = sample(c(0, 1), n, replace = TRUE, prob = c(0.85, 0.15)),
    Outcome = sample(c("Survived", "Deceased"), n, replace = TRUE, prob = c(0.82, 0.18))
  )
  
  # Ensure processed output directory exists
  dir.create(dirname(cleaned_data_output), recursive = TRUE, showWarnings = FALSE)
  write_csv(simulated_data, cleaned_data_output)
  message("Simulated data created at: ", cleaned_data_output)
} else {
  # Load raw dataset
  raw_df <- read_csv(raw_data_path)
  
  # Clean and parse columns
  cleaned_df <- raw_df %>%
    # Filter out records missing primary outcomes
    filter(!is.na(Outcome)) %>%
    # Format clinical values (handling impossible bounds)
    mutate(
      Age = ifelse(Age < 0 | Age > 120, NA, Age),
      CRP = ifelse(CRP < 0, NA, CRP),
      D_Dimer = ifelse(D_Dimer < 0, NA, D_Dimer),
      LDH = ifelse(LDH < 0, NA, LDH),
      Lymphocytes = ifelse(Lymphocytes < 0, NA, Lymphocytes),
      # Convert factors
      Sex = factor(Sex),
      Outcome = factor(Outcome, levels = c("Survived", "Deceased"))
    )
  
  # Write cleaned data
  write_csv(cleaned_df, cleaned_data_output)
  message("Cleaned data successfully written to: ", cleaned_data_output)
}
