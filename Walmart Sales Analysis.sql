######## 	WALMART SALES DATA ANALYSIS
CREATE DATABASE IF NOT EXISTS walmartsales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
	time TIME NOT NULL,
	payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_income_pct FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1) NOT NULL
);
-- TABLE
SELECT * FROM sales;


-- QUERIES AND Business Questions;
-- 1. Data Cleaning

# Since we specified not null in most columns, we should not have null values in our dataset.

-- 2. Feature Engineering ----------------------------------------------------------------------------------------
## Add a column "time of day" to give insight on Morning, Afternoon or Night sales.

SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END) AS time_of_the_day
FROM sales;

-- Add the column to table
ALTER TABLE sales ADD COLUMN time_of_the_day VARCHAR(20);

UPDATE sales
SET time_of_the_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END);


-- Add day_name, useful for visualization and insights on the sales per day of the week ------------------------------------------------------------------------------------------
SELECT date,
	DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(15);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name ------------------------------------------------------------------------------------------------------
SELECT date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name = MONTHNAME(date);

####### 2. Exploratory Data Analysis
-- EDA -- Business Analysis & Queries ---------------------------------------------------------------------------

## Generic Business Questions
-- 1. How many unique cities does the data have?

SELECT DISTINCT(city)
FROM sales; -- 3 main Cities

-- 2. In which city is each branch?
SELECT DISTINCT(branch)
FROM sales;

SELECT DISTINCT(city), branch
FROM sales;


-- Product Business Questions --------------------------------------------------------------------------
-- 1. How many unique product lines does data have?
SELECT DISTINCT(product_line)
FROM sales; 

-- 2. Most Common Payment Method
Select COUNT(*), payment_method from sales
GROUP BY payment_method;

-- 3. What product line has largest revenue?
SELECT * FROM sales;

SELECT SUM(total) as total_per_prod_line, product_line
FROM sales
GROUP BY product_line
ORDER BY total_per_prod_line DESC;

-- 4. What is the total revenue per month?
SELECT month_name, SUM(total) as total_per_month
FROM sales
GROUP BY month_name
ORDER BY total_per_month DESC;

-- 5. What month had largest cost of goods sold?
SELECT month_name, SUM(cogs) as cogs_per_month
FROM sales
group BY month_name
ORDER BY cogs_per_month DESC;

-- 6. What city has largest revenue?
SELECT city, SUM(total) as total_per_city
FROM sales
group BY city
ORDER BY total_per_city DESC;

-- 7. What product line has largest VAT?
SELECT product_line, AVG(VAT) as average_tax
FROM sales
group BY product_line
ORDER BY average_tax DESC;

-- 8. What is the average rating of each product line?
SELECT ROUND(AVG(rating),2) as avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- SALES Analysis -------------------------------------------------------------------------
-- 1. Number of sales made in each time of the day per weekday.
SELECT time_of_the_day, COUNT(*) as total_sales
FROM sales
GROUP BY time_of_the_day;

-- 2. Which customer types brings the most revenue?
SELECT customer_type, SUM(total) as total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;


-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(VAT) as avg_tax
FROM sales
GROUP BY city
ORDER BY avg_tax DESC;

-- CUSTOMERS ----------------------------------------------------------------------------
-- 1. Which time of the day do customers give most ratings?
SELECT time_of_the_day, AVG(rating) as avg_rating
FROM sales
GROUP BY time_of_the_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;




