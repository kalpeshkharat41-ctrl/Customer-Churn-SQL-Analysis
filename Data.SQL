-- Sample Seed Data Insertion Script
INSERT INTO Customer_Churn_Synthetic (CREATE TABLE Customer_Churn_Synthetic(CustomerID , Age ,Gender ,Tenure_Months, Balance , NumOfProducts,HasCrCard , IsActiveMember, EstimatedSalary , Churn) 
FROM 'C:\Users\Lenovo\Downloads\DATASET\customer_churn_synthetic'
DELIMITER ','
CSV HEADER;