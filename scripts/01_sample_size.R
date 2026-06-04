# ==== 01. SAMPLE SIZE CALCULATION ====

# Using pmsampsize library (Rilet et al.) to determine the number of observations required for the developed prognostic model.

# We will use the following parameters:
# - Prevalece of the outcome: 45.5%
# - Number of candidate predictors: 14
# - Shrinkage parameter: 0.05

# Load the libraries
library(pmsampsize)

pmsampsize(
    type = "b", # Binary outcome as model predicts mortality in a dichotomous fashion (alive or deceased)
    cstatistic = 0.75, # Anticipated AUC-ROC of the model, being 0.75 a conservative yet reasonable value for prediction models.
    parameters = 30, # Number of candidate predictors that are intended to be included in the models.
    shrinkage = 0.9, # Shrinkage parameter for the models, being 0.05 a typical value for this parameter. This ensures that the models performance does not reduce by 5% on unseen data (Cox-Snell R^2 = 0.1845).
    prevalence = 0.47 # Prevalence of in-hospital mortality of COVID-19 from Peruvian publications in 2020 (corresponding to COVID-19 first wave).
)

# ==== Results ====

# Assuming 0.05 acceptable difference in apparent & adjusted R-squared
# Assuming 0.05 margin of error in estimation of intercept
# Events per Predictor Parameter (EPP) assumes prevalence = 0.47

#             Samp_size Shrinkage Parameter CS_Rsq Max_Rsq Nag_Rsq   EPP
# Criteria 1      1308     0.900        30 0.1845   0.749   0.246   20.49
# Criteria 2       709     0.831        30 0.1845   0.749   0.246   11.11
# Criteria 3       383     0.900        30 0.1845   0.749   0.246    6.00
# Final           1308     0.900        30 0.1845   0.749   0.246   20.49

# Minimum sample size required for new model development based on user inputs = 1308, with 615 events (assuming an outcome prevalence = 0.47) and an EPP = 20.49
