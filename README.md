# ---SQL-Retail-Sales-Analysis---P1

**Retail Sales Analysis SQL Project**
**Project Overview**
Project Title: Retail Sales Analysis
Level: Beginner
Database: p1_retail_db
Author: Shreyash
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.
Objectives
Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
Database Setup
1. Create Database
-- Create the database for retail sales analysis
CREATE DATABASE p1_retail_db;
USE p1_retail_db;
2. Create Table Structure
-- Drop table if exists
DROP TABLE IF EXISTS retail_sales;

-- Create the retail_sales table
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
3. Data Import
The data is imported from the CSV file 'SQL - Retail Sales Analysis_utf.csv' containing 2000+ retail sales transactions.
Data Exploration & Cleaning
Initial Data Exploration
-- Total number of sales
SELECT COUNT(*) as total_sale FROM retail_sales;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- Distinct product categories
SELECT DISTINCT category FROM retail_sales;
Data Cleaning
-- Check for NULL values in critical columns
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Delete rows with NULL values in critical columns
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

**Q1: Retrieve all columns for sales made on '2022-11-05'**
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

**Q2: Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in November 2022**
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;
    
**Q3: Calculate the total sales (total_sale) for each category**
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

**Q4: Find the average age of customers who purchased items from the 'Beauty' category**
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

**Q5: Find all transactions where the total_sale is greater than 1000**
SELECT * FROM retail_sales
WHERE total_sale > 1000;

**Q6: Find the total number of transactions made by each gender in each category**
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

**Q7: Calculate the average sale for each month and find the best selling month in each year**
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;


**Q8: Find the top 5 customers based on the highest total sales**
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

**Q9: Find the number of unique customers who purchased items from each category**
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

**Q10: Create time shifts and count number of orders (Morning <12, Afternoon 12-17, Evening >17)**
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

**Key Findings**
1. Customer Demographics
The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing, Beauty, and Electronics.
Beauty category customers have the lowest average age, indicating younger demographic preference.
2. Sales Performance
Electronics category generates the highest total revenue, followed by Clothing and Beauty.
Multiple transactions recorded total sale amounts greater than 1000, indicating premium purchases.
3. Temporal Patterns
Sales show clear seasonal variations, with November being the peak month in both years analyzed.
Afternoon hours (12 PM - 5 PM) witness the highest number of transactions, followed by evening and morning shifts.
4. Customer Behavior
A small group of top customers contributes significantly to overall revenue (Pareto principle).
Gender distribution varies across categories, with specific gender preferences for different product types.
5. Transaction Insights
Clothing category shows high-volume transactions in November, possibly due to seasonal shopping.
Most customers purchase from multiple categories, indicating diverse shopping patterns.
Technical Implementation Details
Database Information
Database System: MySQL
Total Records: 2000+ transactions
Data Period: 2022-2023
File Format: CSV with UTF-8 encoding
SQL Concepts Demonstrated
Data Definition Language (DDL): CREATE TABLE, DROP TABLE
Data Manipulation Language (DML): SELECT, DELETE
Aggregation Functions: COUNT, SUM, AVG
Window Functions: RANK() OVER()
Date/Time Functions: EXTRACT(), TO_CHAR()
Conditional Logic: CASE statements
Common Table Expressions (CTEs): WITH clause
Grouping and Filtering: GROUP BY, HAVING, WHERE

**Project Structure**
text
retail-sales-analysis/
├── data/
│   └── SQL - Retail Sales Analysis_utf.csv
├── sql_scripts/
│   ├── 01_database_setup.sql
│   ├── 02_data_import.sql
│   ├── 03_data_cleaning.sql
│   └── 04_analysis_queries.sql
├── documentation/
│   └── README.md
└── results/
    └── analysis_findings.txt
How to Run the Project
Prerequisites
MySQL Server installed
MySQL Workbench or command-line client
CSV data file available
Steps to Execute
Database Setup:
-- Run the database creation script
CREATE DATABASE p1_retail_db;
USE p1_retail_db;
Table Creation:
-- Execute the CREATE TABLE statement
Data Import:
Use MySQL Workbench Import Wizard or
Run LOAD DATA INFILE command
Run Analysis Queries:
-- Execute queries in sequential order
-- Q1 through Q10
Business Applications
The insights from this analysis can help:
Inventory Management: Stock high-demand categories appropriately
Marketing Strategy: Target specific customer segments effectively
Staff Scheduling: Align workforce with peak sales hours
Sales Forecasting: Predict seasonal trends and prepare accordingly
Customer Retention: Identify and reward high-value customers
Pricing Strategy: Optimize pricing for different product categories
Limitations and Future Enhancements
Current Limitations
Limited to 2022-2023 data
No customer demographic details beyond age and gender
No geographic location data
Single data source
Future Enhancements
Integrate customer loyalty program data
Add competitor pricing analysis
Implement predictive modeling for sales forecasting
Create interactive dashboards using Tableau/Power BI
Add real-time data streaming capabilities
Conclusion
This SQL project successfully demonstrates the complete data analysis workflow from database setup to business insights generation. The analysis reveals meaningful patterns in customer behavior, sales trends, and product performance that can inform strategic business decisions. The project showcases essential SQL skills required for entry-level data analyst positions and provides a solid foundation for more advanced analytics projects.
________________________________________
Author: Shreyash
Project Duration: 1 day
Tools Used: MySQL, MySQL Workbench, Excel for initial data review

