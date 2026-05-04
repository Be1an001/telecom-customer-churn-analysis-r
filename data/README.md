# Data Note

This folder contains the CSV files used in the original course project, along with a data dictionary reference.

## Files

- `telecom_customer_churn.csv` - main customer-level telecom churn dataset
- `telecom_zipcode_population.csv` - zipcode-level population reference table
- `telecom_data_dictionary.csv` - variable definitions for the customer churn and zipcode population tables

## Scope

The customer churn table contains **7,043 rows** and **38 columns**. Each row represents one telecom customer in California, with demographic, location, service, billing, revenue, and customer status fields.

The zipcode population table contains **1,671 rows** and **2 columns**. It provides population estimates by ZIP code.

During the analysis, the two files were merged by `Zip.Code` so the churn analysis could include geographic context. The merged dataset described in the report contains **39 columns**.

## Notes for Analysis

- The main status field is `Customer.Status`, with values such as `Stayed`, `Churned`, and `Joined`.
- The EDA removes `Joined` customers when comparing stayed vs. churned customers.
- Some blank service fields appear to be structural blanks for customers who did not subscribe to that service type.
- `Churn.Category` and `Churn.Reason` are useful for business interpretation, but they should not be used as model predictors because they describe information known after churn.

These files are included so the project structure and main EDA workflow are easier to follow.
