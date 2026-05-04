# Telecom Customer Churn Analysis with R

This repository contains my Spring 2024 final project for **ALY6015 - Intermediate Analytics** at Northeastern University, Silicon Valley.

This was a **course-based group project** completed with **Cheng Liu** and **Chandana Yalavarthi**. The public portfolio version focuses on the part I contributed most directly: R-based data preparation, exploratory analysis, visualizations, segmentation, and business interpretation.

## Project Type and Status

- **Project type:** R-based customer churn EDA / business analytics project
- **Main tools:** R, tidyverse, dplyr, ggplot2, gridExtra, pheatmap
- **Main evidence:** EDA script, final report, final presentation, selected output figures, and data dictionary
- **Status:** Course/portfolio project, not a production churn model or deployed dashboard

## Business Problem

Customer churn is important for telecom companies because losing existing customers can reduce recurring revenue and increase the need for new customer acquisition. This project explores which customer characteristics, service patterns, and geographic segments are associated with churn so a retention or marketing team could better understand where to focus attention.

The analysis is mainly exploratory and diagnostic. It is intended to support retention-focused discussion, not to prove causal drivers of churn.

## Project Objective

The project was built around four main questions:

1. What factors appear to be associated with customer retention?
2. How can customers be segmented for retention or marketing strategies?
3. What service usage patterns relate to churn?
4. How well can churn be predicted using logistic regression and regularized models?

## Dataset

The original course project used two CSV files:

- `data/telecom_customer_churn.csv`
- `data/telecom_zipcode_population.csv`

The customer churn table contains **7,043 rows** and **38 columns**. The zipcode population table contains **1,671 rows** and **2 columns**. The two datasets were merged by `Zip.Code`, creating a merged dataset with **39 columns**.

The main status field is `Customer.Status`, with customers labeled as `Stayed`, `Churned`, or `Joined`. For the stayed-vs-churned EDA comparisons, customers with status `Joined` were removed because they were not part of the churn comparison.

See [data/README.md](./data/README.md) for the data note.

## My Role

My main contribution focused on:

- data merging and inspection
- missing value review
- exploratory data analysis in R
- churn pattern analysis
- customer segmentation
- Bay Area city-level analysis
- interpretation of business insights

The original course submission also included a basic modeling section with logistic regression, lasso, ridge, and ROC/AUC discussion. That modeling section was primarily contributed by my teammate and is preserved through the final report and slide deck. The local repository does not currently contain a clean standalone modeling script, so the modeling should be treated as a documented team-project component rather than a production-ready model.

## Methodology

The main EDA workflow is documented in [scripts/01_eda_analysis.R](./scripts/01_eda_analysis.R) and explained in [docs/eda-walkthrough.md](./docs/eda-walkthrough.md).

The workflow includes:

- loading the customer churn and zipcode population datasets
- merging the datasets by ZIP code
- checking structure, summary statistics, and missing values
- removing `Joined` customers for stayed-vs-churned comparisons
- exploring numerical and categorical feature distributions
- comparing churn patterns by contract type, tenure, payment method, marital status, and churn reason
- creating a clustered correlation heatmap for numeric variables
- analyzing churn rates by city and selected Bay Area cities

## Key Findings

Some of the main patterns observed in the project were:

- Month-to-month customers showed much higher churn than one-year or two-year contract customers.
- Customers with shorter tenure churned more often than customers with longer tenure.
- Unmarried customers showed higher churn than married customers.
- Payment method appeared related to churn; credit card users showed lower churn than bank withdrawal and mailed check users in the EDA.
- Among churned customers with a provided reason, competitor-related reasons and dissatisfaction were common themes.
- Some Bay Area cities showed higher churn rates, but city-level findings need caution because small customer counts can make rates unstable.
- Age was explored as part of the EDA, but contract type and tenure were clearer churn-related patterns in this portfolio version.

These findings should be read as associations from exploratory analysis, not causal conclusions.

## Visual Highlights

### Contract vs Customer Status
![Contract vs Customer Status](./outputs/figures/contract-vs-customer-status.jpg)

### Tenure in Months vs Customer Status
![Tenure in Months vs Customer Status](./outputs/figures/tenure-in-months-vs-customer-status.jpg)

### Clustered Correlation Heatmap
![Clustered Correlation Heatmap](./outputs/figures/clustered-correlation-heatmap.jpg)

### Churn Rate by Bay Area Cities
![Churn Rate by Bay Area Cities](./outputs/figures/churn-rate-by-bay-area-cities.jpg)

## Repository Structure

- `scripts/01_eda_analysis.R` - main EDA script for the part of the project I worked on most directly
- `scripts/02_modeling_note.md` - note about the modeling section from the original group project
- `docs/eda-walkthrough.md` - readable walkthrough of the EDA workflow and findings
- `outputs/figures/` - selected visual outputs preserved from the project
- `reports/final-project-report.pdf` - final written report
- `slides/final-project-presentation.pdf` - final presentation
- `archive/` - earlier course deliverables
- `data/README.md` - dataset note for the public version
- `data/telecom_data_dictionary.csv` - reference file for variable definitions

## How to Run or Reproduce

The main analysis script is [scripts/01_eda_analysis.R](./scripts/01_eda_analysis.R).

To reproduce the EDA:

1. Open the project folder in R or RStudio.
2. Install the R packages used in the script if needed: `tibble`, `ggplot2`, `tidyverse`, `gridExtra`, `pheatmap`, and `dplyr`.
3. Run `scripts/01_eda_analysis.R` from the repository root so the `data/` paths resolve correctly.

The script displays the main plots but does not currently export every committed JPG figure automatically.

## Limitations

- This is a course-based portfolio project, not a production analytics system.
- The repository does not include a deployed dashboard or app.
- The modeling section is documented in the final report and slides, but the local repository does not include a clean standalone modeling workflow.
- The reported ROC/AUC result should be treated as course-project evidence and would need stronger validation before any production use.
- `Churn.Category` and `Churn.Reason` are useful for explaining why churn happened, but they should not be used as predictors in a real churn model because they are known after the customer has churned.
- City-level churn rates can be unstable when customer counts are small.
- The analysis shows associations, not causal proof.

## Future Improvements

Potential improvements for a later phase include:

- add a reproducible R environment file such as `renv.lock`
- make the EDA script export figures consistently
- add clearer data-quality notes for structural blanks and negative monthly charges
- add churn-rate tables with minimum sample-size filters for city analysis
- rebuild the modeling section as a standalone reproducible script with train/test validation
- add model evaluation details such as baseline comparison, confusion matrix, and threshold discussion
- optionally create a small Shiny or Streamlit-style dashboard if the project is later repositioned as an app

## Related Files

- [EDA Walkthrough](./docs/eda-walkthrough.md)
- [Modeling Note](./scripts/02_modeling_note.md)
- [Final Report](./reports/final-project-report.pdf)
- [Final Presentation](./slides/final-project-presentation.pdf)
- [M2 Proposal / Dataset Selection](./archive/m2-proposal-dataset-selection.pdf)
- [M4 Initial Analysis Report](./archive/m4-initial-analysis-report.pdf)
