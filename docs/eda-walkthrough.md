# EDA Walkthrough

This page is a cleaner walkthrough of the exploratory data analysis part of my ALY6015 final project.

This was a group project completed in **ALY6015 – Intermediate Analytics** at Northeastern University, Silicon Valley.  
The work here mainly reflects the part I worked on most directly: data preparation, exploratory analysis, churn pattern exploration, segmentation, and Bay Area city-level analysis.

---

## Quick Links

- [EDA script](../scripts/01_eda_analysis.R)
- [Modeling note](../scripts/02_modeling_note.md)
- [Final report](../reports/final-project-report.pdf)
- [Final presentation](../slides/final-project-presentation.pdf)
- [Telecom dataset](../data/telecom_customer_churn.csv)
- [Zipcode dataset](../data/telecom_zipcode_population.csv)

---

## 1. Project Goal

The purpose of this analysis was to understand which factors were associated with customer churn and which patterns could help explain customer retention.

I mainly focused on:
- preparing the merged dataset
- checking missing values
- exploring numerical and categorical variables
- comparing stayed vs. churned customers
- analyzing churn reasons
- examining geographic churn patterns, especially in Bay Area cities

---

## 2. Load and Merge the Data

I used two datasets stored in the repository:

- `data/telecom_customer_churn.csv`
- `data/telecom_zipcode_population.csv`

The two tables were merged by `Zip.Code` so that the churn analysis could include geographic context.

```r
telecom <- read.csv("data/telecom_customer_churn.csv")
zipcode <- read.csv("data/telecom_zipcode_population.csv")

merged_telecom <- merge(
  telecom,
  zipcode,
  by.x = "Zip.Code",
  by.y = "Zip.Code",
  all.x = TRUE
)

merged_telecom <- as_tibble(merged_telecom)
```

This step created one combined dataset for the rest of the analysis.

---

## 3. Initial Data Review

Before building any plots, I checked the structure, summary statistics, and missing values.

```r
str(merged_telecom)
summary(merged_telecom)
sapply(merged_telecom, function(x) sum(is.na(x)))
```

This helped me understand:
- the size of the dataset
- the variable types
- where missing values appeared

I also removed customers with status `Joined` for the stayed-vs-churned comparison.

```r
merged_telecom <- merged_telecom %>% 
  filter(Customer.Status != "Joined")
```

This made the churn comparison more consistent for EDA.

---

## 4. Distribution of Numerical Features

I first looked at the distribution of several numerical variables, including:
- Age
- Monthly Charge
- Total Charges
- Total Refunds
- Total Long Distance Charges
- Total Revenue

```r
numerical_features <- c(
  "Age",
  "Monthly.Charge",
  "Total.Charges",
  "Total.Refunds",
  "Total.Long.Distance.Charges",
  "Total.Revenue"
)
```

### Output
![Distribution of Numerical Features](../outputs/figures/distribution-of-numerical-features.jpg)

### Main Takeaway
Several revenue-related variables were right-skewed. Monthly charge also showed multiple peaks, which may reflect different pricing or service plan groups.

---

## 5. Distribution of Categorical Features

I then reviewed several major categorical variables:
- Gender
- Married
- Payment Method
- Customer Status
- Churn Category

I replaced blank churn categories with `Did not provide` so the plots would be easier to read.

```r
merged_telecom$Churn.Category[merged_telecom$Churn.Category == ""] <- "Did not provide"
```

### Output
![Distribution of Categorical Features](../outputs/figures/distribution-of-categorical-features.jpg)

### Main Takeaway
Gender looked fairly balanced overall, while payment method and churn-related fields showed more visible differences.

---

## 6. Categorical Features by Customer Status

Next, I compared several categorical variables by `Customer.Status`, especially:
- Gender
- Married
- Payment Method
- Churn Category

```r
merged_telecom$Customer.Status <- factor(
  merged_telecom$Customer.Status,
  levels = c("Stayed", "Churned")
)
```

### Output
![Categorical Features by Customer Status](../outputs/figures/categorical-features-by-customer-status.jpg)

### Main Takeaway
Gender did not look like a strong differentiator, but marital status and payment method appeared more informative. Unmarried customers and some payment behavior patterns were associated with higher churn.

---

## 7. Churn Reasons

To make churn reasons easier to interpret, I replaced blank values in `Churn.Reason` with `Did not provide`, then reordered the categories by count.

```r
merged_telecom$Churn.Reason[merged_telecom$Churn.Reason == ""] <- "Did not provide"
```

### Output
![Count of Churn Reasons](../outputs/figures/count-of-churn-reasons.jpg)

### Main Takeaway
Among customers who gave a reason, competition and dissatisfaction were important churn themes. A large share of records had no specific reason provided.

---

## 8. Contract Type and Customer Status

I wanted to see whether contract type was related to churn.

```r
ggplot(merged_telecom, aes(x = Contract, fill = Contract)) +
  geom_bar() +
  facet_wrap(~ Customer.Status)
```

### Output
![Contract vs Customer Status](../outputs/figures/contract-vs-customer-status.jpg)

### Main Takeaway
Month-to-month customers showed much higher churn than customers on one-year or two-year contracts. This was one of the clearest patterns in the project.

---

## 9. Tenure and Customer Status

I also compared `Tenure.in.Months` between stayed and churned customers.

```r
ggplot(
  merged_telecom,
  aes(x = Customer.Status, y = Tenure.in.Months, fill = Customer.Status)
) +
  geom_boxplot()
```

### Output
![Tenure in Months vs Customer Status](../outputs/figures/tenure-in-months-vs-customer-status.jpg)

### Main Takeaway
Customers who stayed generally had much longer tenure. Short-tenure customers were much more likely to churn.

---

## 10. Age Distribution by Customer Status

To compare age patterns, I used a density plot.

```r
ggplot(merged_telecom, aes(x = Age, fill = Customer.Status)) +
  geom_density(alpha = 0.5)
```

### Output
![Age Distribution by Customer Status](../outputs/figures/age-distribution-by-customer-status.jpg)

### Main Takeaway
Younger customers appeared slightly more likely to churn, while older customers looked somewhat more stable.

---

## 11. Correlation Heatmap

To better understand numeric relationships, I created a correlation matrix and clustered heatmap.

```r
numeric_vars <- merged_telecom[, sapply(merged_telecom, is.numeric)]
correlation_matrix <- cor(numeric_vars, use = "complete.obs")
```

### Output
![Clustered Correlation Heatmap](../outputs/figures/clustered-correlation-heatmap.jpg)

### Main Takeaway
Revenue-related variables were strongly correlated with each other. This helped show which variables moved together and which might be redundant in later modeling.

---

## 12. Geographic Churn Analysis

I also explored whether churn patterns varied by population density, city, and Bay Area location.

### Churn Rate by City
![Churn Rate by City](../outputs/figures/churn-rate-by-city.jpg)

### Churn Rate by Bay Area Cities
![Churn Rate by Bay Area Cities](../outputs/figures/churn-rate-by-bay-area-cities.jpg)

### Customer Status by Bay Area Cities
![Customer Status by Bay Area Cities](../outputs/figures/customer-status-by-bay-area-cities-count.jpg)

### Main Takeaway
Some cities showed higher churn rates than others, including several Bay Area cities. These results were useful for segmentation, but they should be interpreted carefully because some cities may have small sample sizes.

---

## 13. Final EDA Summary

This EDA helped identify several useful churn-related patterns:

- churn was higher among month-to-month customers
- shorter-tenure customers were more likely to churn
- marital status and payment behavior appeared more useful than gender
- competition and dissatisfaction showed up frequently in churn reasons
- geography added useful segmentation context

This part of the project gave the business side of the team project a clearer story before moving into the modeling section.