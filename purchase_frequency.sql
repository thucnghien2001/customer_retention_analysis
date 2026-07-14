-- I. Create the database, table and insert data.
USE superstore_sale;

CREATE TABLE sales (Row_ID INT,
					Order_ID VARCHAR(50),
                    Order_Date TEXT,
                    Ship_Date TEXT,
                    Ship_Mode VARCHAR(50),
                    Customer_ID VARCHAR(50),
                    Customer_Name VARCHAR(50),
                    Segment VARCHAR(50),
                    Country VARCHAR(50),
                    City VARCHAR(50),
                    State VARCHAR(50),
                    Postal_Code INT NULL,
                    Region VARCHAR(30),
                    Product_ID VARCHAR(50),
                    Category VARCHAR(50),
                    Sub_Category VARCHAR(50),
                    Product_Name VARCHAR(255),
                    Sales DECIMAL(10,2),
                    Quantity INT,
                    Discount DECIMAL(4,2),
                    Profit DECIMAL(10,2));
                    
SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/Administrator/Downloads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- II. Data Quality Check
SELECT * FROM sales;
-- 1. Check the total number of records and the number of rows
SELECT COUNT(*) FROM sales;
-- There are 9994 records in the dataset.

DESCRIBE sales;

-- 2. Check if there is duplicate in the dataset.
SELECT COUNT(Row_ID) total_rows,
		COUNT(DISTINCT Row_ID) unique_rows
FROM sales;
-- The dataset has no duplicate rows.

SELECT COUNT(Order_ID) total_num_orders,
		COUNT(DISTINCT Order_ID) distinct_orders
FROM sales;
-- The total number of listed orders is 9994, while the distinct number of orders is in fact 5009
-- There are duplicated values in Order_ID. One order may have different product categories.

-- 3. Check the time period of the dataset
SELECT Order_Date, Ship_Date FROM sales;

UPDATE sales
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y'); 

UPDATE sales
SET Ship_Date = STR_TO_DATE(Ship_Date, '%m/%d/%Y');

ALTER TABLE sales
MODIFY COLUMN Order_date DATE;

ALTER TABLE sales
MODIFY COLUMN Ship_date DATE;

DESCRIBE sales;	

SELECT MIN(Order_Date) AS First_Order,
		MAX(Order_Date) AS Last_Order
FROM sales;
-- the dataset records sales information from 2014-01-03 to 2017-12-30 or from 2014-2017 (4 years)

-- 4. Check the total number of customers and orders
SELECT COUNT(DISTINCT customer_ID) AS total_customer,
		COUNT(DISTINCT order_ID) AS total_order
FROM sales;
-- there are 793 customers in total
-- there are 5009 orders in total

-- 5. Check if there are abnormal values.
SELECT sales, quantity
FROM sales
WHERE sales < 0 OR quantity < 0;
-- there is no sales or quantity that are less than 0

SELECT discount
FROM sales
WHERE discount > 1 OR discount < 0;
-- the discount value is between 0 and 1

SELECT COUNT(profit)
FROM sales
WHERE profit < 0;
-- there are 1871 orders that had negative profit 

-- II. EXPLORARY DATA ANALYSIS (EDA)
-- Check the gross revenue and gross profit.
SELECT SUM(sales) AS gross_revenue, 
		SUM(profit) AS gross_profit
FROM sales;
-- the gross revenue is USD 2,297,201.07 and the gross profit is USD 286,397.79 
 
-- Check the total number of orders by year.
 SELECT YEAR(Order_Date) AS order_year, COUNT(DISTINCT Order_ID) AS total_order
 FROM sales
 GROUP BY order_year
 ORDER BY total_order;
 -- There was the highest numbers of orders in 2017 (1687) and the lowest number of orders in 2014 (969). the numbers of orders increased over time.
 
 -- Check the total number of customers by year.
SELECT YEAR(Order_Date) AS order_year, COUNT(DISTINCT Customer_ID) AS total_customer
 FROM sales
 GROUP BY order_year
 ORDER BY total_customer;
 -- There was the highest number of customers in 2017 (693) and the lowest number of customers in 2015 (573)
 
 -- Check the total revenue by year.
 SELECT YEAR(Order_Date) AS order_year, SUM(sales) AS total_revenue
 FROM sales
 GROUP BY order_year
 ORDER BY total_revenue;
 -- There was the highest revenue in 2017 and the lowest revenue in 2015
 -- the number of orders in 2015 is higher than in 2014 but resulted in lower revenue. 
 -- -> Average Order Value (AOV) in 2015 is lower than in 2014
 
 -- Check the total profit by year. 
 SELECT YEAR(Order_Date) AS order_year, SUM(profit) AS total_profit
 FROM sales
 GROUP BY order_year
 ORDER BY total_profit;
 -- the total profit of 2014 is lower than that of 2015. Maybe the discount in 2014 is higher than in 2015.
 
WITH purchase_frequency AS (
SELECT customer_ID,
		COUNT(Distinct Order_ID) AS order_num
FROM sales
GROUP BY customer_ID
ORDER BY order_num DESC)
SELECT AVG(order_num) AS Avg_purchase_frequency
FROM purchase_frequency;
-- the highest purchase frequency is 17 and the lowest purchase frequency is 1.
-- the average purchase frequency is 6.32

-- Create customer_purchase_frequency table
CREATE VIEW customer_purchase_frequency AS 
SELECT customer_id,
		customer_name,
        COUNT(DISTINCT order_id) as order_num,
        CASE
			WHEN COUNT(DISTINCT order_id) = 1 THEN '1 Purchase'
            WHEN COUNT(DISTINCT order_id) BETWEEN 2 AND 3 THEN '2-3 Purchases'
            WHEN COUNT(DISTINCT order_id) BETWEEN 4 AND 5 THEN '4-5 Purchases'
            WHEN COUNT(DISTINCT order_id) BETWEEN 6 AND 10 THEN '6-10 Purchases'
            ELSE 'More than 10 Purchases'
        END AS Frequency_group
FROM sales
GROUP BY customer_id, customer_name
ORDER BY 3;

-- Check the total customers in each purchase frequency group
SELECT frequency_group,
        COUNT(DISTINCT customer_id)
FROM customer_purchase_frequency
GROUP BY frequency_group;
  
  -- Create customer_revenue table
CREATE VIEW Customer_Revenue AS (
SELECT customer_id,
		customer_name,
        SUM(sales) AS total_sales
FROM sales
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC);
 
 -- Create customer_revenue_ratio table using WINDOW FUNCTION
 CREATE VIEW customer_revenue_ratio AS
 WITH customer_revenue AS(
 SELECT customer_id,
		customer_name,
        SUM(sales) AS total_sales
FROM sales
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC)
SELECT customer_id,
		customer_name,
        total_sales,
        ROUND(total_sales/SUM(total_sales) OVER() * 100, 4) AS sales_ratio,
        SUM(total_sales) OVER(ORDER BY total_sales DESC) as cumulative_sales,
        ROUND(SUM(total_sales) OVER(ORDER BY total_sales DESC)/SUM(total_sales) OVER() * 100,4) AS cumulative_sales_ratio,
        ROW_NUMBER() OVER(ORDER BY total_sales DESC) AS customer_rank
FROM customer_revenue;
DROP VIEW customer_revenue_ratio;

-- Check the average discount in each category
SELECT AVG(discount) FROM sales
WHERE category = "Furniture";
-- Average discount of Furniture is 0.17

SELECT AVG(discount) FROM sales
WHERE category = "Technology";
-- Average discount of Technology is 0.13

SELECT AVG(discount) FROM sales
WHERE category = "Office Supplies";
-- Average discount of Office Supplies is 0.16

-- Customer Retention Analysis using Cohort
SELECT COUNT(*) FROM sales
WHERE YEAR(Order_date) = 2017;
-- There are 3312 records in 2017

-- Create first purchase month of each customer.
CREATE VIEW Cohort_Matrix AS
WITH Order_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, DATE_FORMAT(Order_date, '%Y-%m-01') AS Order_Month 
FROM sales
)
-- SELECT * FROM Order_Month
, Cohort_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, Order_Month, MIN(Order_Month) OVER(PARTITION BY Customer_ID) AS Cohort_Month
FROM Order_Month
)
-- SELECT * FROM Cohort_Month
, Cohort_Index AS (
SELECT *, TIMESTAMPDIFF(month, Cohort_Month, Order_Month) + 1 AS Cohort_Index
FROM Cohort_Month
)
SELECT * FROM Cohort_Index;

-- Create cohort_matrix in 2017 
CREATE VIEW Cohort_Matrix_17 AS
WITH sales_2017 AS (
SELECT * FROM sales
WHERE YEAR(Order_date) = 2017
)
-- SELECT * FROM sales_2017
, Order_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, DATE_FORMAT(Order_date, '%Y-%m-01') AS Order_Month 
FROM sales_2017
)
-- SELECT * FROM Order_Month
, Cohort_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, Order_Month, MIN(Order_Month) OVER(PARTITION BY Customer_ID) AS Cohort_Month
FROM Order_Month
)
-- SELECT * FROM Cohort_Month
, Cohort_Index AS (
SELECT *, TIMESTAMPDIFF(month, Cohort_Month, Order_Month) + 1 AS Cohort_Index
FROM Cohort_Month
)
-- SELECT * FROM Cohort_Index
, retention AS (
SELECT Cohort_Month,
		Cohort_Index,
        COUNT(DISTINCT customer_ID) AS Active_Customers
FROM Cohort_Index
GROUP BY 1, 2
)
-- SELECT * FROM retention
, cohort_size AS (
SELECT Cohort_Month,
		Active_Customers AS Cohort_size
FROM retention
WHERE Cohort_Index = 1
)
SELECT r.cohort_month,
		r.cohort_index,
        r.active_customers,
        c.cohort_size,
        ROUND(active_customers/cohort_size * 100, 2) AS retention_rate
FROM retention r
JOIN cohort_size c
	ON r.cohort_month = c.cohort_month;
    
-- Create New and Returning Customer Table
CREATE VIEW New_ReturningCustomer AS
WITH sales_2017 AS (
SELECT * FROM sales
WHERE YEAR(Order_date) = 2017
)
-- SELECT * FROM sales_2017
, Order_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, DATE_FORMAT(Order_date, '%Y-%m-01') AS Order_Month 
FROM sales_2017
)
-- SELECT * FROM Order_Month
, Cohort_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, Order_Month, MIN(Order_Month) OVER(PARTITION BY Customer_ID) AS Cohort_Month
FROM Order_Month
)
-- SELECT * FROM Cohort_Month
, New_Customer AS (
SELECT Order_Month,
		COUNT(DISTINCT customer_ID) AS New_Customer
FROM Cohort_Month
WHERE Order_Month = Cohort_Month
GROUP BY Order_Month
ORDER BY Order_Month
)
-- SELECT * FROM New_Customer
, Returning_Customer AS (
SELECT Order_Month,
		COUNT(DISTINCT customer_id) AS Returning_Customer
FROM Cohort_Month
WHERE Order_Month != Cohort_Month
GROUP BY Order_Month
ORDER BY Order_Month
)
SELECT n.Order_Month,
		n.New_Customer,
        r.Returning_Customer
FROM New_Customer n
LEFT JOIN Returning_Customer r
	ON n.Order_Month = r.Order_Month;
 
-- Create Revenue Retention table in 2017
CREATE VIEW Revenue_Retention AS
WITH sales_2017 AS (
SELECT * FROM sales
WHERE YEAR(Order_date) = 2017
)
-- SELECT * FROM sales_2017
, Order_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, sales, profit, DATE_FORMAT(Order_date, '%Y-%m-01') AS Order_Month 
FROM sales_2017
)
-- SELECT * FROM Order_Month
, Cohort_Month AS (
SELECT Order_ID, Customer_ID, Customer_Name, sales, profit, Order_Month, MIN(Order_Month) OVER(PARTITION BY Customer_ID) AS Cohort_Month
FROM Order_Month
)
-- SELECT * FROM Cohort_Month
, Cohort_Index AS (
SELECT *, TIMESTAMPDIFF(month, Cohort_Month, Order_Month) + 1 AS Cohort_Index
FROM Cohort_Month
)
-- SELECT * FROM Cohort_Index
, Revenue AS (
SELECT Cohort_Month,
		Cohort_Index,
        SUM(sales) AS Revenue
FROM Cohort_Index
GROUP BY 1, 2
)
-- SELECT * FROM Revenue
, Revenue_size AS (
SELECT Cohort_Month,
		SUM(sales) AS Revenue_size
FROM Cohort_Index
WHERE Cohort_Index = 1
GROUP BY Cohort_Month
)
SELECT r.cohort_month,
		r.cohort_index,
        r.revenue,
        rz.revenue_size,
        ROUND(revenue/revenue_size * 100, 2) AS revenue_retention_rate
FROM Revenue r
JOIN Revenue_size rz
	ON r.cohort_month = rz.cohort_month
 ORDER BY 1, 2;           
                    
                    

