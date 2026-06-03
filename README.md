# COVID-19 Mortality Prediction using Explainable Machine Learning

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R-version](https://img.shields.io/badge/R-%3E%3D%204.0-blue.svg)](https://www.r-project.org/)

This repository contains the complete analytical pipeline for predicting COVID-19 mortality using machine learning models integrated with SHAP (SHapley Additive exPlanations) for model interpretability. The workflow is designed in accordance with the **TRIPOD** (Transparent Reporting of a multivariable prediction model for Individual Prognosis Or Diagnosis) guidelines to ensure transparency, reproducibility, and clinical relevance.

---

## 📂 Directory Structure

```
covid19-mortality-ml-prediction/
├── README.md              ← Professional, publication-linked repository documentation
├── LICENSE                ← MIT License
├── .gitignore             ← Git exclusion patterns (excludes large data, .rds, and .RData)
├── CITATION.cff           ← Citation metadata for academic referencing
├── renv.lock              ← Reproducible package environment lockfile
├── data/
│   ├── README.md          ← Data dictionary and instructions (raw data is not committed)
│   └── processed/         ← Aggregated, non-sensitive summary output CSVs
├── scripts/               ← Numbered, execution-ordered analysis pipeline
│   ├── 00_setup.R         ← Environment and dependency setup
│   ├── 01_data_cleaning.R ← Initial data cleaning and formatting
│   ├── 02_preprocessing.R ← Imputation, scaling, and feature engineering
│   ├── 03_rf_training.R   ← Random Forest model training and tuning
│   ├── 04_xgboost_svm.R   ← XGBoost and Support Vector Machine training
│   ├── 05_logistic_regression.R ← Baseline Logistic Regression
│   ├── 06_model_comparison.R   ← Evaluation metrics, ROC, and PR curves
│   ├── 07_shap_analysis.R      ← SHAP-based global and local interpretability
│   ├── 08_learning_curves.R    ← Sample size vs. performance diagnostics
│   ├── 09_calibration.R        ← Probability calibration curves and Brier scores
│   └── 10_figures.R            ← Main and supplementary figure generation
├── results/
│   ├── tables/            ← Model metrics, odds ratios, and diagnostic tables
│   └── figures/           ← Plots (ROC, SHAP, calibration, learning curves)
├── manuscript/
│   └── tripod_checklist.xlsx  ← TRIPOD statement compliance documentation
└── docs/
    ├── session_info.txt   ← Detailed R session version information
    └── codebook.md        ← Comprehensive variable definitions and mappings
```

---

## 🚀 Getting Started

### Prerequisites
- R (version $\ge$ 4.0 recommended)
- [RStudio](https://posit.co/download/rstudio-desktop/) (optional, but recommended)

### Environment Setup (Reproducibility)
This project uses `renv` to manage package dependencies. To restore the exact package versions used in this analysis:

1. Open the project in R/RStudio.
2. Initialize and restore the library:
   ```R
   install.packages("renv")
   renv::restore()
   ```

---

## 🛠 Running the Pipeline

To reproduce the analysis from raw data to final figures, run the scripts in `scripts/` in chronological order:

```bash
# Run the setup script to verify packages
Rscript scripts/00_setup.R

# Execute the pipeline step-by-step
Rscript scripts/01_data_cleaning.R
Rscript scripts/02_preprocessing.R
Rscript scripts/03_rf_training.R
Rscript scripts/04_xgboost_svm.R
Rscript scripts/05_logistic_regression.R
Rscript scripts/06_model_comparison.R
Rscript scripts/07_shap_analysis.R
Rscript scripts/08_learning_curves.R
Rscript scripts/09_calibration.R
Rscript scripts/10_figures.R
```

---

## 📊 Models Evaluated
- **Random Forest (RF)**: Ensemble bagger for capturing non-linear feature interactions.
- **Extreme Gradient Boosting (XGBoost)**: Gradient-boosted trees optimized for high performance.
- **Support Vector Machine (SVM)**: Radial Basis Function (RBF) kernel SVM.
- **Logistic Regression**: Standard baseline to compare against clinical benchmarks.

---

## 🧪 Model Interpretability (SHAP)
We employ TreeSHAP and KernelSHAP to compute Shapley values for both global feature importance and individual patient risk explanations. This ensures clinical applicability and transparency.

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ✍️ Citation
If you use this code or model in your research, please cite it using the metadata in [CITATION.cff](CITATION.cff) or as follows:

```bibtex
@software{Lama_COVID19_Mortality_2026,
  author = {Lama Agurto, Javier A.},
  title = {{COVID-19 Mortality Prediction using Explainable Machine Learning}},
  year = {2026},
  url = {https://github.com/javi-lama/covid19-mortality-ml-prediction}
}
```
