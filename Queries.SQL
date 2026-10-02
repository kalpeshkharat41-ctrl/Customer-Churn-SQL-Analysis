--Customer_Churn_Synthetic Queries

--------------------------------------------------------------------------------
-- LEVEL 1: EASY QUESTIONS
--------------------------------------------------------------------------------
1.Display all customer records from the table.
SELECT * FROM Customer_Churn_Synthetic;

2.Display only CustomerID, Age, Gender, and Balance for all customers.
SELECT customerId,age, gender, balance
FROM Customer_Churn_Synthetic;

3.Find the total number of customers in the dataset.
SELECT COUNT(customerId) AS total_number_of_customers
FROM Customer_Churn_Synthetic;

4.Find the average age of all customers.
SELECT AVG(age) AS average_age
FROM Customer_Churn_Synthetic;

5.Display customers whose Balance is greater than ₹40,000.
SELECT customerId,balance
FROM Customer_Churn_Synthetic
WHERE balance>40000;

--------------------------------------------------------------------------------
-- LEVEL 2: MODERATE QUESTIONS
--------------------------------------------------------------------------------
1.Find the number of customers in each Gender.
SELECT gender, COUNT(customerId) AS No_of_Customers
FROM Customer_Churn_Synthetic
GROUP BY gender;

2.Find the average Balance for each Gender.
SELECT gender, AVG(balance) AS Avg_Balance
FROM Customer_Churn_Synthetic
GROUP BY gender;

3.Find the number of customers who have churned (Churn = 1) and the number who have not churned (Churn = 0).
SELECT churn, COUNT(customerId) AS No_of_Customers
FROM Customer_Churn_Synthetic
GROUP BY churn;

4.Find the average EstimatedSalary of active and inactive customers separately using IsActiveMember.
SELECT CASE WHEN IsActiveMember = 1 THEN 'Active' ELSE 'Iactive' END AS Member_status , AVG(estimatedsalary) AS average_EstimatedSalary
FROM Customer_Churn_Synthetic
GROUP BY IsActiveMember;

5.Find the top 10 customers with the highest Balance, displaying CustomerID, Age, Balance, and Churn.
SELECT customerId,balance,age,churn
FROM Customer_Churn_Synthetic
GROUP BY customerId
ORDER BY balance DESC
LIMIT 10 ;

--------------------------------------------------------------------------------
-- LEVEL 3: ADVANCED QUESTIONS
--------------------------------------------------------------------------------
1.Calculate the churn rate (%) for each Gender.
Display:
A.Gender
B.Total Customers
C.Churned Customers
D.Churn Rate %
SELECT gender,COUNT(customerId) AS Total_Customers, SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,(CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(customerId)) AS "Churn_Rate_%"
FROM Customer_Churn_Synthetic
GROUP BY gender;

2.Find the average Balance and average EstimatedSalary for each combination of IsActiveMember and Churn.
SELECT AVG(balance) AS Average_Balance ,AVG(estimatedsalary) AS Average_EstimatedSalary, IsActiveMember, churn
FROM Customer_Churn_Synthetic
GROUP BY IsActiveMember,churn;

3.Find the top 5 age groups with the highest churn rate, where the age groups are:
18–30
31–40
41–50
51–60
61+
WITH CategorizedCustomers AS (SELECT Churn,CASE WHEN Age BETWEEN 18 AND 30 THEN '18-30' WHEN Age BETWEEN 31 AND 40 THEN '31-40' WHEN Age BETWEEN 41 AND 50 THEN '41-50' WHEN Age BETWEEN 51 AND 60 THEN '51-60' ELSE '61+' END AS Age_Group
FROM Customer_Churn_Synthetic)
SELECT 
    Age_Group,
    (CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100 AS "Churn_Rate_%"
FROM CategorizedCustomers
GROUP BY Age_Group
ORDER BY "Churn_Rate_%" DESC
LIMIT 5;

4.Find customers whose Balance is higher than the overall average Balance and who have also churned. Display their CustomerID, Age, Balance, EstimatedSalary, and Churn.
SELECT CustomerID, Age, Balance, EstimatedSalary, Churn
FROM Customer_Churn_Synthetic
WHERE Balance > (SELECT AVG(Balance) FROM Customer_Churn_Synthetic)
  AND Churn = 1;

5.Identify the Gender with the highest churn rate, but return the result using a query rather than simply sorting the result manually. Display:
A.Gender
B.Total Customers
C.Churned Customers
D.Churn Rate %  
SELECT gender,COUNT(customerId) AS Total_Customers, SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,(CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(customerId)) AS "Churn_Rate_%"
FROM Customer_Churn_Synthetic
GROUP BY gender
ORDER BY "Churn_Rate_%" DESC 
LIMIT 1 ;