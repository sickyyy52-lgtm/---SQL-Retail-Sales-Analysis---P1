CREATE DATABASE sql_project_p1;
USE sql_project_p1;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,	
    sale_date DATE,	 
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),	
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Note: You need to load the CSV data into the table
-- This can be done using MySQL's LOAD DATA INFILE or through import wizard
-- Example for MySQL:
-- LOAD DATA INFILE 'path/to/SQL - Retail Sales Analysis_utf.csv'
-- INTO TABLE retail_sales
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- After loading data, check the table
SELECT * FROM retail_sales LIMIT 10;

-- Check total records
SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
-- First, check for NULL values in critical columns
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    -- Delete rows with NULL values in critical columns
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    -- Data Exploration

-- 1. How many sales do we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- 2. How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as unique_customers FROM retail_sales;

-- 3. Check distinct categories
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Questions

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND MONTH(sale_date) = 11
    AND YEAR(sale_date) = 2022
    AND quantity > 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as total_sales,
    COUNT(*) as transaction_count
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) as average_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- Q.6 Write a SQL query to find the total number of transactions made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) as sale_year,
        MONTH(sale_date) as sale_month,
        AVG(total_sale) as avg_sale,
        SUM(total_sale) as total_sales,
        COUNT(*) as transaction_count
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_months AS (
    SELECT *,
        RANK() OVER(PARTITION BY sale_year ORDER BY total_sales DESC) as month_rank
    FROM monthly_sales
)
SELECT 
    sale_year,
    sale_month,
    avg_sale,
    total_sales,
    transaction_count
FROM ranked_months
WHERE month_rank = 1
ORDER BY sale_year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_spent,
    COUNT(*) as purchase_count
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Q.10 Write a SQL query to create each shift and number of orders
-- Morning (<12), Afternoon (12-17), Evening (>17)
WITH time_shifts AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as time_shift
    FROM retail_sales
)
SELECT 
    time_shift,
    COUNT(*) as order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales), 2) as percentage
FROM time_shifts
GROUP BY time_shift
ORDER BY order_count DESC;

-- Additional useful queries:

-- 11. Daily sales trend
SELECT 
    sale_date,
    SUM(total_sale) as daily_sales,
    COUNT(*) as daily_transactions
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;

-- 12. Customer segmentation by spending
SELECT 
    customer_id,
    SUM(total_sale) as total_spent,
    COUNT(*) as transaction_count,
    CASE
        WHEN SUM(total_sale) > 5000 THEN 'VIP'
        WHEN SUM(total_sale) > 2000 THEN 'Regular'
        ELSE 'Casual'
    END as customer_segment
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 13. Product performance analysis
SELECT 
    category,
    AVG(price_per_unit) as avg_price,
    SUM(quantity) as total_quantity_sold,
    SUM(total_sale) as total_revenue,
    ROUND(AVG(total_sale), 2) as avg_transaction_value
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- 14. Hourly sales pattern
SELECT 
    HOUR(sale_time) as hour_of_day,
    COUNT(*) as transaction_count,
    SUM(total_sale) as hourly_sales
FROM retail_sales
GROUP BY HOUR(sale_time)
ORDER BY hour_of_day;

-- 15. Age group analysis
SELECT 
    CASE
        WHEN age < 20 THEN 'Teen'
        WHEN age BETWEEN 20 AND 35 THEN 'Young Adult'
        WHEN age BETWEEN 36 AND 50 THEN 'Adult'
        WHEN age > 50 THEN 'Senior'
        ELSE 'Unknown'
    END as age_group,
    COUNT(*) as customer_count,
    SUM(total_sale) as total_sales,
    ROUND(AVG(total_sale), 2) as avg_spent
FROM retail_sales
WHERE age IS NOT NULL
GROUP BY age_group
ORDER BY total_sales DESC;


-- End of project






