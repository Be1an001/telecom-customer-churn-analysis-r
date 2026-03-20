#-----------------#
# ALY6015 - Intermediate Analytics @Silicon Valley Campus #
# Final Project - Telecom Customer Churn Analysis #
# May.05.2024 #
# Cheng Liu #
#-----------------#

# Import the library
library(tibble)
library(ggplot2)
library(tidyverse)
library(gridExtra)
library(pheatmap)
library(dplyr)

# Load the datasets
telecom <- read.csv("Telecom Customer Churn Prediction Dataset/telecom_customer_churn.csv")
zipcode <- read.csv("Telecom Customer Churn Prediction Dataset/telecom_zipcode_population.csv")

# Merge the datasets based on Zip Code
merged_telecom <- merge(telecom, zipcode, by.x = "Zip.Code", by.y = "Zip.Code", all.x = TRUE)
merged_telecom <- as_tibble(merged_telecom)

# Check the datasets
str(merged_telecom)
summary(merged_telecom)

# Check for missing values
sapply(merged_telecom, function(x) sum(is.na(x)))

# Remove joined for customer status
merged_telecom <- merged_telecom %>% filter(Customer.Status != 'Joined')

# Numerical features
numerical_features <- c('Age', 'Monthly.Charge','Total.Charges', 'Total.Refunds', 
                        'Total.Long.Distance.Charges', 'Total.Revenue')

# Plot distribution of numerical features
numerical_plots <- lapply(numerical_features, function(feature) {
  ggplot(merged_telecom, aes_string(x = feature)) +
    geom_histogram(aes(y = ..density..), bins = 30, fill = "blue", alpha = 0.7) +
    geom_density(col = "red", size = 1) +
    ggtitle(paste("Distribution of", feature)) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(x = feature, y = "Density")
})
grid.arrange(grobs = numerical_plots, ncol = 3)

# Categorical features
merged_telecom$Churn.Category[merged_telecom$Churn.Category == ""] <- "Did not provide"
categorical_features <- c('Gender', 'Married', 'Payment.Method', 'Customer.Status', 'Churn.Category')

# Plotting distribution of categorical features
categorical_plots <- lapply(categorical_features, function(feature) {
  ggplot(merged_telecom, aes_string(x = feature)) +
    geom_bar(fill = "blue", alpha = 0.7) +
    ggtitle(paste("Count of", feature)) +
    theme_minimal() +
    geom_text(stat = 'count', aes(label = ..count..), vjust = 0.5) +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(x = feature, y = "Count") +
    coord_flip()
})
grid.arrange(grobs = categorical_plots, ncol = 2)

# Bar plot for categorical features by customer status
categorical_features <- c('Gender', 'Married', 'Payment.Method', 'Churn.Category')
merged_telecom$Customer.Status <- factor(merged_telecom$Customer.Status, levels = c("Stayed", "Churned"))

# Create individual plots for each categorical feature
categorical_plots <- lapply(categorical_features, function(feature) {
  ggplot(merged_telecom, aes_string(x = feature, fill = "Customer.Status")) +
    geom_bar(position = 'dodge', alpha = 0.7) +
    geom_text(stat = 'count', aes(label = ..count..), position = position_dodge(width = 0.9), vjust = 0.3) +
    ggtitle(paste("Count of", feature, "by Customer Status")) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(x = feature, y = 'Count') +
    scale_fill_manual(values = c("blue", "red"))
})
grid.arrange(grobs = categorical_plots, ncol = 2)

# Calculate counts of churn reason and reorder factor levels by count
merged_telecom$Churn.Reason[merged_telecom$Churn.Reason == ""] <- "Did not provide"
churn_reason <- merged_telecom %>%
  count(Churn.Reason) %>%
  arrange(n)

# Convert churn reason to a factor with levels ordered by count
merged_telecom$Churn.Reason <- factor(merged_telecom$Churn.Reason, levels = churn_reason$Churn.Reason)

# Bar plot for count of churn reason
ggplot(merged_telecom, aes(x = Churn.Reason)) +
  geom_bar(fill = "blue", alpha = 0.7) +
  geom_text(stat = 'count', aes(label = ..count..), vjust = 0.3) +
  ggtitle("Count of Churn Reasons") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = 'Churn Reason', y = 'Count')

# Bar plot for contract vs. customer status
ggplot(merged_telecom, aes(x = Contract, fill = Contract)) + geom_bar() + facet_wrap(~ Customer.Status)

# Box plot for tenure in months vs. customer status
ggplot(merged_telecom, aes(x = Customer.Status, y = Tenure.in.Months, fill = Customer.Status)) +
  geom_boxplot() +
  labs(title = "Tenure in Months vs. Customer Status", x = "Customer Status", y = "Tenure in Months") +
  theme_minimal()

# Density Plot for age distribution by customer status
ggplot(merged_telecom, aes(x = Age, fill = Customer.Status)) +
  geom_density(alpha = 0.5) +
  labs(title = "Age Distribution by Customer Status", x = "Age", y = "Density") +
  theme_minimal()

# Calculate the correlation matrix
numeric_vars <- merged_telecom[, sapply(merged_telecom, is.numeric)]
correlation_matrix <- cor(numeric_vars, use = "complete.obs")
correlation_matrix

# Plot the heat map with hierarchical clustering
pheatmap(correlation_matrix, clustering_distance_rows = "correlation", clustering_distance_cols = "correlation",
         display_numbers = TRUE, fontsize_number = 10, main = "Clustered Correlation Heatmap")

# Churn rate by population density
# Define low & medium & high population category
population_categories <- cut(merged_telecom$Population, breaks = quantile(merged_telecom$Population, probs = c(0, 0.33, 0.66, 1)), 
                             labels = c("Low", "Medium", "High"), include.lowest = TRUE)

merged_telecom <- merged_telecom %>%
  mutate(Population_Category = population_categories)

# Calculate churn rate by population category
churn_rate_by_pop <- merged_telecom %>%
  group_by(Population_Category, Customer.Status) %>%
  summarise(Count = n()) %>%
  mutate(Churn_Rate = Count / sum(Count))

# Plot churn rate by population category
ggplot(churn_rate_by_pop, aes(x = Population_Category, y = Churn_Rate, fill = Customer.Status)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Churn Rate by Population Density", x = "Population Density", y = "Churn Rate") +
  theme_minimal()

# Calculate churn rate by city
churn_rate_by_city <- merged_telecom %>%
  group_by(City) %>%
  summarise(Total_Customers = n(),
            Churned_Customers = sum(Customer.Status == "Churned"),
            Churn_Rate = Churned_Customers / Total_Customers * 100) %>%
  arrange(desc(Churn_Rate))

# Plot churn rate by top 20 city
ggplot(churn_rate_by_city[1:20, ], aes(x = reorder(City, Churn_Rate), y = Churn_Rate, fill = City)) +
  geom_bar(stat = "identity") +
  labs(title = "Churn Rate by City", x = "City", y = "Churn Rate (%)") +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none")

# Define bay area cities
bay_area_cities <- c("San Francisco", "Oakland", "San Jose", "Berkeley", "Fremont", 
                     "Palo Alto", "Sunnyvale", "Santa Clara", "Mountain View", 
                     "Redwood City", "Menlo Park", "Cupertino", "Milpitas")

# Filter the dataset for bay area cities
merged_telecom_bay_area <- merged_telecom %>% filter(City %in% bay_area_cities)

# Calculate churn rate by city within Bay Area
churn_rate_by_bay_area <- merged_telecom_bay_area %>%
  group_by(City) %>%
  summarize(
    Total_Customers = n(),
    Churned_Customers = sum(Customer.Status == "Churned"),
    Churn_Rate = Churned_Customers / Total_Customers
  )

# Plot churn rate by bay area city
ggplot(churn_rate_by_bay_area, aes(x = reorder(City, Churn_Rate), y = Churn_Rate, fill = City)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Churn Rate by Bay Area Cities") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = 'City', y = 'Churn Rate') +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent)

# Plot customer status by Bay Area city
ggplot(merged_telecom_bay_area, aes(x = City, fill = Customer.Status)) +
  geom_bar(position = "dodge", alpha = 0.7) +
  coord_flip() +
  ggtitle("Customer Status by Bay Area Cities") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = 'City', y = 'Count') +
  scale_fill_manual(values = c("blue", "red"))

# Stacked bar plot customer status by Bay Area city
ggplot(merged_telecom_bay_area, aes(x = City, fill = Customer.Status)) +
  geom_bar(position = "fill", alpha = 0.7) +
  coord_flip() +
  ggtitle("Customer Status by Bay Area Cities") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = 'City', y = 'Proportion') +
  scale_fill_manual(values = c("blue", "red")) +
  scale_y_continuous(labels = scales::percent)
