-- ==========================================================
-- Database Schema: Customer_Churn_Synthetic Dataset
-- ==========================================================
CREATE TABLE Customer_Churn_Synthetic(CustomerID INTEGER PRIMARY KEY, Age INTEGER,Gender VARCHAR(10),Tenure_Months INTEGER, Balance DECIMAL(10,2), NumOfProducts INTEGER,HasCrCard INTEGER, IsActiveMember INTEGER, EstimatedSalary DECIMAL(10,2), Churn INTEGER);