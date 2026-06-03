# Variable Codebook

This document defines the schema, types, and descriptions of the clinical variables used in the COVID-19 mortality prediction machine learning models.

## 📋 Demographic & Comorbidity Predictors

| Variable Name | Type | Allowed Values / Units | Description |
|---|---|---|---|
| `Patient_ID` | Integer | Unique identifier | Primary key for anonymized patients. |
| `Age` | Integer | Years ($0 - 120$) | Patient age at the time of admission. |
| `Sex` | Categorical | `Male`, `Female` | Patient physiological sex. |
| `Diabetes` | Binary | `0` (No), `1` (Yes) | History of Type 1 or Type 2 Diabetes Mellitus. |
| `Hypertension` | Binary | `0` (No), `1` (Yes) | History of chronic systemic hypertension. |
| `Cardiovascular`| Binary | `0` (No), `1` (Yes) | Pre-existing cardiovascular disease (e.g., CAD, Heart Failure). |

## 🧪 Laboratory Biomarkers (at Admission)

| Variable Name | Type | Normal Range / Units | Clinical Significance / Notes |
|---|---|---|---|
| `CRP` | Numeric | $< 5.0$ mg/L | C-reactive protein. Biomarker of systemic inflammation. |
| `D_Dimer` | Numeric | $< 0.50$ mg/L FEU | Biomarker of fibrin degradation and hypercoagulability. |
| `LDH` | Numeric | $140 - 280$ U/L | Lactate Dehydrogenase. General marker of tissue damage. |
| `Lymphocytes` | Numeric | $1.0 - 4.8 \times 10^9$/L | Absolute lymphocyte count. Low values signal immunodepletion. |

## 🎯 Target Outcomes

| Variable Name | Type | Allowed Values | Description |
|---|---|---|---|
| `ICU_Admission`| Binary | `0` (No), `1` (Yes) | Admission to the Intensive Care Unit during hospitalization. |
| `Outcome` | Categorical| `Survived`, `Deceased` | **Primary Target Variable**. Patient discharge status. |
