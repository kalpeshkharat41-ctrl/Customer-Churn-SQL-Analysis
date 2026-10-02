Customer Churn SQL Analysis
📌 Project Overview

This project focuses on analyzing a synthetic customer churn dataset using SQL.

The objective is to practice and demonstrate SQL skills by exploring customer demographics, account information, balances, activity status, salaries, and churn behavior.

The analysis progresses from Basic → Moderate → Advanced SQL queries, covering filtering, aggregation, grouping, conditional logic, subqueries, CTEs, and churn-rate calculations.

📊 Dataset Description

The dataset contains customer-level information related to banking/customer retention.

Columns
Column	Description
CustomerID	Unique identifier for each customer
Age	Age of the customer
Gender	Gender of the customer
Tenure_Months	Number of months the customer has been with the company
Balance	Customer account balance
NumOfProducts	Number of products held by the customer
HasCrCard	Indicates whether the customer has a credit card (1 = Yes, 0 = No)
IsActiveMember	Indicates whether the customer is an active member (1 = Yes, 0 = No)
EstimatedSalary	Estimated annual salary of the customer
Churn	Indicates whether the customer has churned (1 = Churned, 0 = Not Churned)
🗄️ Table Structure
CREATE TABLE Customer_Churn_Synthetic(
    CustomerID INTEGER PRIMARY KEY,
    Age INTEGER,
    Gender VARCHAR(10),
    Tenure_Months INTEGER,
    Balance DECIMAL(10,2),
    NumOfProducts INTEGER,
    HasCrCard INTEGER,
    IsActiveMember INTEGER,
    EstimatedSalary DECIMAL(10,2),
    Churn INTEGER
);
🎯 Project Objectives

The main objectives of this project are:

Explore customer records using SQL.
Calculate customer counts and averages.
Analyze customers based on gender.
Compare active and inactive members.
Identify churned and non-churned customers.
Find customers with higher account balances.
Calculate churn rates.
Analyze churn across different age groups.
Use subqueries to compare customers against overall averages.
Identify the gender with the highest churn rate.
🟢 Basic SQL Analysis

The basic section focuses on fundamental SQL concepts.

Questions Covered
Display all customer records.
Display selected customer information such as CustomerID, Age, Gender, and Balance.
Calculate the total number of customers.
Calculate the average customer age.
Find customers with a balance greater than ₹40,000.
SQL Concepts Used
SELECT
FROM
WHERE
COUNT()
AVG()
Column selection
Filtering
🟡 Moderate SQL Analysis

The moderate section focuses on grouping and conditional analysis.

Questions Covered
Find the number of customers in each gender.
Calculate the average balance for each gender.
Count churned and non-churned customers.
Calculate the average estimated salary of active and inactive members.
Find the top 10 customers with the highest balance.
SQL Concepts Used
GROUP BY
ORDER BY
LIMIT
COUNT()
AVG()
CASE WHEN
Aggregate functions
🔴 Advanced SQL Analysis

The advanced section focuses on more complex analytical queries.

Questions Covered
1. Churn Rate by Gender

Calculates:

Total customers
Churned customers
Churn rate percentage

The churn rate is calculated as:

Churn Rate % = Churned Customers / Total Customers × 100
2. Balance and Salary by Activity & Churn

Analyzes the average:

Balance
Estimated Salary

for each combination of:

Active/Inactive Member
Churned/Not Churned
3. Churn Rate by Age Group

Customers are categorized into:

18–30
31–40
41–50
51–60
61+

The churn rate is then calculated for each age group.

4. Customers Above Average Balance Who Churned

Uses a subquery to identify customers whose balance is:

Higher than the overall average balance
And who have churned
5. Gender with the Highest Churn Rate

Uses aggregation and sorting to identify the gender having the highest calculated churn rate.

🧠 SQL Skills Demonstrated

This project demonstrates the following SQL concepts:

Basic
SELECT
WHERE
COUNT
AVG
Column aliases
Intermediate
GROUP BY
ORDER BY
LIMIT
CASE WHEN
Multiple aggregations
Advanced
CTE (WITH)
Subqueries
Conditional aggregation
CAST
Churn-rate calculations
Multi-column grouping
Analytical filtering
📈 Key Analytical Metrics

The project focuses on several important customer-retention metrics:

Metric	Purpose
Total Customers:Measures the customer base
Churned Customers:Measures customers who left
Churn Rate %:Measures the proportion of customers who churned
Average Balance:Measures typical customer account balance
Average Estimated Salary:Compares customer salary levels
Active Member Status:Helps analyze customer engagement
Age Group Churn Rate:Identifies differences in churn across age groups
💡 Business Questions Addressed

This SQL analysis can help answer questions such as:

How many customers are currently in the dataset?
How does customer balance differ by gender?
How many customers have churned?
Are active and inactive customers different in terms of estimated salary?
Which customers have the highest balances?
Which age groups have higher churn rates?
Are high-balance customers also represented among churned customers?
How does churn vary between genders?

📂 Project Structure
Customer-Churn-SQL-Analysis/
│
├── schema.sql DDL: Customer_Churn_Synthetic table creation
├── data.sql   DML: Customer churn dataset insertion
├── queries.sql SQL analysis queries: Basic, Moderate, and Advanced
└── README.md  Project documentation and SQL analysis overview