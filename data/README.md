# Data Directory

This directory is structured to store the raw and processed datasets used in this analysis.

> [!WARNING]
> **Data Privacy & Compliance**: 
> Never commit raw patient-level data (raw electronic health records, Protected Health Information - PHI) to GitHub. This directory's contents are gitignored, except for `.gitkeep` and this `README.md`.

## 📁 Directory Layout

- `data/` : Place raw de-identified datasets here locally (e.g., `.csv` or `.rds` formats). This directory is ignored by Git to prevent accidental exposure of raw data.
- `data/processed/` : Stores summary-level or aggregated statistics that do not contain individual patient identifiers. These processed summary datasets are allowed to be checked into git when necessary.

## 📊 Variable Schema

The expected columns for the raw dataset and processed outputs are detailed in [codebook.md](../docs/codebook.md).
Key clinical variables of interest include:
- Demographics: Age, Sex, Comorbidities (Diabetes, Hypertension, Cardiovascular disease, etc.)
- Laboratory values at admission (e.g., CRP, D-dimer, LDH, Lymphocyte count)
- Outcomes: Survival status / ICU admission
