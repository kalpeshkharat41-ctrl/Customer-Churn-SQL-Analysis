# Customer Churn Analysis using PostgreSQL

Analysing 1,000 bank customers with SQL to understand who churns, how churn differs by gender, age, activity and balance, and which customers are most at risk.

**Headline finding:** Only 17 of 1,000 customers (1.7%) churned, but they share a very clear profile. Every one of them was an inactive member, had been a customer for 11 months or less, and held a balance under ₹10,000. No active member and no customer with a balance above ₹10,000 churned.

---

## Business Problem

The bank wants to know:

- How many customers do we have, and what do they look like (age, gender, balance)?
- What share of customers churn?
- Does churn differ by gender or age group?
- Are inactive members more likely to leave than active ones?
- Do high-balance customers churn, and are they worth protecting?

## Dataset

| Item | Detail |
|---|---|
| File | `customer_churn_synthetic.csv` |
| Rows | 1,000 (one row per customer) |
| Columns | 10 |
| Missing values | None |
| Duplicates | None (`CustomerID` is unique) |
| Target column | `Churn` (1 = churned, 0 = stayed) |

| Column | Description |
|---|---|
| `CustomerID` | Unique customer ID (1 to 1,000) |
| `Age` | Customer age (18 to 69) |
| `Gender` | Male (524) or Female (476) |
| `Tenure_Months` | Months as a customer (1 to 71) |
| `Balance` | Account balance (9.42 to 49,985.69) |
| `NumOfProducts` | Number of bank products held (1 to 4) |
| `HasCrCard` | 1 if the customer has a credit card |
| `IsActiveMember` | 1 if the customer is active (exactly 500 active, 500 inactive) |
| `EstimatedSalary` | Estimated yearly salary (20,121 to 149,677) |
| `Churn` | 1 if the customer left |

> The dataset is labelled synthetic, so it was generated rather than collected from real customers. See Limitations.

## Tools

PostgreSQL, pgAdmin (or DBeaver), SQL (aggregations, CASE, subqueries, CTEs)

## Data Preparation

1. Created the table with suitable types (`DECIMAL` for money, `INTEGER` for the 0/1 flags).
2. Loaded the CSV with `COPY`.
3. Checked row count (1,000), NULLs (0) and duplicate IDs (0).

```sql
\copy Customer_Churn_Synthetic FROM 'customer_churn_synthetic.csv' WITH (FORMAT csv, HEADER true);
```

---

## SQL Skills Demonstrated

`SELECT / WHERE / ORDER BY / LIMIT` · `GROUP BY` · `CASE WHEN` · conditional aggregation · scalar subquery · CTE

---

## Analysis and Results

### Basic

| # | Question | Result |
|---|---|---|
| 1 | View all customer records | 1,000 rows |
| 2 | Show CustomerID, Age, Gender, Balance | 1,000 rows |
| 3 | Total customers | 1,000 |
| 4 | Average age | 43.82 years |
| 5 | Customers with balance above ₹40,000 | 214 |

```sql
-- Q3
SELECT COUNT(customerid) AS total_customers
FROM Customer_Churn_Synthetic;

-- Q4
SELECT ROUND(AVG(age), 2) AS average_age
FROM Customer_Churn_Synthetic;

-- Q5
SELECT customerid, balance
FROM Customer_Churn_Synthetic
WHERE balance > 40000;
```

### Moderate

**1. Customers by gender**

```sql
SELECT gender, COUNT(customerid) AS no_of_customers
FROM Customer_Churn_Synthetic
GROUP BY gender;
```

| Gender | Customers |
|---|---|
| Male | 524 |
| Female | 476 |

**2. Average balance by gender**

```sql
SELECT gender, ROUND(AVG(balance), 2) AS avg_balance
FROM Customer_Churn_Synthetic
GROUP BY gender;
```

| Gender | Avg balance |
|---|---|
| Male | ₹25,328.36 |
| Female | ₹25,305.39 |

Average balances are almost identical.

**3. Churned vs retained customers**

```sql
SELECT churn, COUNT(customerid) AS no_of_customers
FROM Customer_Churn_Synthetic
GROUP BY churn;
```

| Churn | Customers |
|---|---|
| 0 (stayed) | 983 |
| 1 (churned) | 17 |

**4. Average salary of active vs inactive customers**

```sql
SELECT CASE WHEN isactivemember = 1 THEN 'Active' ELSE 'Inactive' END AS member_status,
       ROUND(AVG(estimatedsalary), 2) AS average_estimated_salary
FROM Customer_Churn_Synthetic
GROUP BY isactivemember;
```

| Member status | Avg estimated salary |
|---|---|
| Inactive | ₹85,402.30 |
| Active | ₹82,329.31 |

**5. Top 10 customers by balance**

```sql
SELECT customerid, age, balance, churn
FROM Customer_Churn_Synthetic
ORDER BY balance DESC
LIMIT 10;
```

| CustomerID | Age | Balance | Churn |
|---|---|---|---|
| 433 | 37 | 49,985.69 | 0 |
| 903 | 46 | 49,977.20 | 0 |
| 621 | 29 | 49,973.31 | 0 |
| 105 | 26 | 49,853.91 | 0 |
| 482 | 34 | 49,806.15 | 0 |
| 760 | 40 | 49,749.07 | 0 |
| 408 | 39 | 49,742.90 | 0 |
| 508 | 43 | 49,732.43 | 0 |
| 824 | 18 | 49,622.11 | 0 |
| 152 | 32 | 49,587.13 | 0 |

None of the 10 highest-balance customers churned.

### Advanced

**1. Churn rate by gender**

```sql
SELECT gender,
       COUNT(customerid) AS total_customers,
       SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(customerid), 2) AS churn_rate_pct
FROM Customer_Churn_Synthetic
GROUP BY gender;
```

| Gender | Total | Churned | Churn rate |
|---|---|---|---|
| Female | 476 | 10 | 2.10% |
| Male | 524 | 7 | 1.34% |

**2. Average balance and salary by activity and churn**

```sql
SELECT isactivemember, churn,
       COUNT(*) AS customers,
       ROUND(AVG(balance), 2) AS average_balance,
       ROUND(AVG(estimatedsalary), 2) AS average_estimated_salary
FROM Customer_Churn_Synthetic
GROUP BY isactivemember, churn
ORDER BY isactivemember, churn;
```

| Active | Churn | Customers | Avg balance | Avg salary |
|---|---|---|---|---|
| 0 | 0 | 483 | ₹25,610.46 | ₹85,625.36 |
| 0 | 1 | 17 | ₹4,788.73 | ₹79,064.78 |
| 1 | 0 | 500 | ₹25,732.33 | ₹82,329.31 |

Only three combinations exist, because no active member churned. Churned customers have an average balance about 80% lower than retained ones, but similar salaries.

**3. Churn rate by age group**

```sql
WITH categorized AS (
    SELECT churn,
           CASE WHEN age BETWEEN 18 AND 30 THEN '18-30'
                WHEN age BETWEEN 31 AND 40 THEN '31-40'
                WHEN age BETWEEN 41 AND 50 THEN '41-50'
                WHEN age BETWEEN 51 AND 60 THEN '51-60'
                ELSE '61+' END AS age_group
    FROM Customer_Churn_Synthetic
)
SELECT age_group,
       COUNT(*) AS customers,
       SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned,
       ROUND(SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM categorized
GROUP BY age_group
ORDER BY churn_rate_pct DESC
LIMIT 5;
```

| Rank | Age group | Customers | Churned | Churn rate |
|---|---|---|---|---|
| 1 | 61+ | 183 | 5 | 2.73% |
| 2 | 18-30 | 238 | 5 | 2.10% |
| 3 | 41-50 | 218 | 3 | 1.38% |
| 4 | 51-60 | 180 | 2 | 1.11% |
| 5 | 31-40 | 181 | 2 | 1.10% |

There are only five age groups, so the top 5 is the full list.

**4. High-balance customers who churned** (balance above the average of 25,317.43)

```sql
SELECT customerid, age, balance, estimatedsalary, churn
FROM Customer_Churn_Synthetic
WHERE balance > (SELECT AVG(balance) FROM Customer_Churn_Synthetic)
  AND churn = 1;
```

**Result: 0 rows.** No churned customer has a balance above average. The highest balance among churned customers is 9,792.04.

**5. Gender with the highest churn rate**

```sql
SELECT gender,
       COUNT(customerid) AS total_customers,
       SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(customerid), 2) AS churn_rate_pct
FROM Customer_Churn_Synthetic
GROUP BY gender
ORDER BY churn_rate_pct DESC
LIMIT 1;
```

**Female**: 476 customers, 10 churned, 2.10% churn rate.

### Extra: what do churned customers have in common?

The advanced questions looked at gender and age, but those differences are small. Checking tenure, balance and activity shows where churn actually sits.

```sql
-- Churn by tenure
SELECT CASE WHEN tenure_months <= 12 THEN '1-12'
            WHEN tenure_months <= 24 THEN '13-24'
            WHEN tenure_months <= 36 THEN '25-36'
            WHEN tenure_months <= 48 THEN '37-48'
            ELSE '49-72' END AS tenure_band,
       COUNT(*) AS customers,
       SUM(churn) AS churned,
       ROUND(AVG(churn) * 100, 2) AS churn_rate_pct
FROM Customer_Churn_Synthetic
GROUP BY tenure_band
ORDER BY tenure_band;

-- Churn by balance
SELECT CASE WHEN balance < 5000 THEN '1. Under 5,000'
            WHEN balance < 10000 THEN '2. 5,000-9,999'
            WHEN balance < 20000 THEN '3. 10,000-19,999'
            ELSE '4. 20,000+' END AS balance_band,
       COUNT(*) AS customers,
       SUM(churn) AS churned,
       ROUND(AVG(churn) * 100, 2) AS churn_rate_pct
FROM Customer_Churn_Synthetic
GROUP BY balance_band
ORDER BY balance_band;
```

| Tenure | Customers | Churned | Churn rate |
|---|---|---|---|
| 1-12 months | 176 | 17 | 9.66% |
| 13-24 months | 194 | 0 | 0% |
| 25-36 months | 175 | 0 | 0% |
| 37-48 months | 163 | 0 | 0% |
| 49-72 months | 292 | 0 | 0% |

| Balance | Customers | Churned | Churn rate |
|---|---|---|---|
| Under 5,000 | 103 | 9 | 8.74% |
| 5,000 - 9,999 | 95 | 8 | 8.42% |
| 10,000 - 19,999 | 189 | 0 | 0% |
| 20,000+ | 613 | 0 | 0% |

Churn also sits at the extremes of product holding: customers with 4 products churn at 3.85% (9 of 234), versus about 0.8% for customers with 2 or 3 products.

---

## Key Insights

1. **Overall churn is low at 1.7%** (17 of 1,000), so the dataset is heavily imbalanced towards customers who stay.
2. **Inactivity is a pre-condition for churn.** All 17 churners were inactive members, and none of the 500 active members churned. Among inactive members the churn rate is 3.4%.
3. **Churn happens early.** All 17 churners had 11 months of tenure or less (average 6.6 months versus 35.1 for retained customers). After month 12, nobody churned.
4. **Churn is a low-balance event.** Every churner had a balance under ₹10,000 (average ₹4,789 versus ₹25,672 for retained customers), and no customer above ₹10,000 churned.
5. **Combined, the pattern is exact:** the 17 inactive customers with 11 months of tenure or less and a balance under ₹10,000 all churned.
6. **High-value customers are safe in this data.** None of the top 10 balances churned, and the query for above-average-balance churners returned zero rows.
7. **Gender and age differences are small.** Women churn at 2.10% versus 1.34% for men, but this is only 10 versus 7 customers, and the difference is not statistically significant (p = 0.46). By age, 61+ (2.73%) and 18-30 (2.10%) are highest, but each group has only 2 to 5 churners.
8. **Customers with 4 products churn about 5 times as often** as those with 2 or 3 (3.85% vs about 0.8%), which suggests over-selling products may not help retention.

## Recommendations

- **Focus on onboarding.** Contact new customers in their first year, because all churn happens within 11 months.
- **Re-engage inactive new customers.** Flag customers who are inactive, under 12 months in, and have a low balance, and run welcome offers or outreach for them.
- **Encourage early deposits.** Customers who build a balance above ₹10,000 early did not churn.
- **Review the 4-product bundle.** Check whether customers with 4 products were sold more than they need.
- **Do not target campaigns by gender.** The gender gap is too small to act on.

## Limitations

- The dataset is synthetic, and the pattern (all churn among inactive, short-tenure, low-balance customers) is too clean for real banking data. Results demonstrate SQL technique, not real-world churn drivers.
- With only 17 churned customers, group-level churn rates (by age, gender or products) rest on very small counts.
- There is no churn date, so the time of departure cannot be analysed.
- Currency is assumed to be ₹, as used in the question wording.

---

## Project Structure

```
├── data/
│   └── customer_churn_synthetic.csv
├── sql/
│   ├── 01_schema_and_loading.sql
│   └── 02_analysis_queries.sql
└── README.md
