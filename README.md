# Auto Insurance Claims Analysis

> **Business analytics project identifying fraud patterns in 1,000 auto insurance claims and recommending a claims-routing strategy that catches 38% of fraud while reviewing only 28% of claims.**

---

## Business problem

A mid-sized auto insurer's claims portfolio is showing a 24.7% fraud rate, with $14.9M in fraud payouts on $52.8M in total claims paid (28% of every dollar). The Claims Operations team needs to know **where fraud is concentrated** and **which claims warrant deeper investigation** so they can route high-risk claims to the Special Investigations Unit (SIU) without overloading senior adjusters.

## Stakeholder

**Director of Claims Operations.** This analysis supports three of their decisions:
1. Where to focus SIU and senior-adjuster review capacity
2. Which customer and incident profiles to flag for underwriting
3. How to design claim-triage rules so high-risk claims hit the right desk first

## Key findings

1. **Fraud is highly concentrated by incident severity.** Claims marked "Major Damage" have a 60.5% fraud rate, vs. 7–13% for all other severities — a 6x difference.

2. **A simple 4-indicator red-flag score scales linearly with fraud risk.** Combining four signals (no police report, no witnesses, unknown collision type, major damage), claims with 0 red flags show a 14% fraud rate, while claims with 3 red flags show 41% — nearly 3x higher.

3. **Two incident profiles drive the majority of fraud.** "Major Damage + Single Vehicle Collision" and "Major Damage + Multi-Vehicle Collision" together represent 28% of claim volume but 67% of all fraud cases.

## Recommendation

> **Route claims with 2 or more red flags to the Special Investigations Unit. This concentrates investigation effort on 28% of the portfolio while catching 38% of all fraud cases — $5.5M in fraud dollars.**
 ## 🔴 Live Interactive Dashboard

**[View the live dashboard on Tableau Public →](https://public.tableau.com/app/profile/tomorrow.lake5414/viz/auto_insurance_dashboard/AutoInsuranceClaimsDashboar)**

A three-view interactive dashboard exploring fraud patterns across the claims portfolio. Includes a KPI overview, fraud rate breakdowns by incident severity and red flag count, and top fraud-risk profiles ranked by combined severity and incident type.

State, gender, and policy tenure showed no meaningful correlation with fraud and should not be used as targeting variables.

## Tools used

- **SQL** — exploratory data queries against the cleaned dataset
- **Spreadsheet (Google Sheets / Excel)** — pivot tables and segment analysis
- **Tableau** — three-view interactive dashboard (Portfolio Overview, Segment Deep-Dive, Fraud Risk Triage)
- **Python (pandas)** — data cleaning and feature engineering

## Repository structure

```
Auto_Insurance_Claims_Analysis/
├── 01_data/              ← Cleaned dataset and data dictionary
├── 02_sql/               ← Exploratory SQL queries
├── 03_workbook/          ← Pivot table workbook
├── 04_tableau/           ← Tableau workbook and dashboard screenshots
├── 05_deliverables/      ← Executive memo (PDF)
└── README.md
```

## Dataset

1,000 auto insurance claims from Ohio, Illinois, and Indiana (2015). Sourced from Kaggle. See [`01_data/data_dictionary.md`](01_data/data_dictionary.md) for full column reference and cleaning notes.

## About this project

Portfolio project built to demonstrate end-to-end business analytics workflow: data cleaning, exploratory analysis, segmentation, dashboard design, and stakeholder-ready recommendations.

**Author:** [tomorrowlake3](https://github.com/tomorrowlake3)
