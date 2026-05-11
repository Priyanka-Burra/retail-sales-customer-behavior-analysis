DROP DATABASE IF EXISTS retail_project;
CREATE DATABASE retail_project;
USE retail_project;

CREATE TABLE sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT
);
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail.csv'
INTO TABLE sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@order_id, @order_date, @ship_date, @ship_mode, @customer_id, @customer_name,
 @segment, @country, @city, @state, @postal_code, @region,
 @product_id, @category, @sub_category, @product_name,
 @sales, @quantity, @discount, @profit)
SET
order_id = @order_id,

-- ✅ FIXED DATE (NO STR_TO_DATE)
order_date = @order_date,
ship_date = @ship_date,

ship_mode = @ship_mode,
customer_id = @customer_id,
customer_name = @customer_name,
segment = @segment,
country = @country,
city = @city,
state = @state,
postal_code = @postal_code,
region = @region,
product_id = @product_id,
category = @category,
sub_category = @sub_category,
product_name = @product_name,

-- ✅ HANDLE NULLS
sales = NULLIF(@sales, ''),
quantity = NULLIF(@quantity, ''),
discount = NULLIF(@discount, ''),

-- ✅ HANDLE INVALID PROFIT
profit = IF(@profit REGEXP '^-?[0-9]+(\\.[0-9]+)?$', @profit, 0);
SELECT COUNT(*) FROM sales;
SELECT * FROM sales LIMIT 10;
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales;
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(sales) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;
SELECT 
    customer_name,
    SUM(sales) AS revenue
FROM sales
GROUP BY customer_name
ORDER BY revenue DESC
LIMIT 10;
SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY category;
-- TOP CUSTOMERS WITH RANK
SELECT 
    customer_name,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS rank_position
FROM (
    SELECT 
        customer_name,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY customer_name 
) t;
SELECT * FROM sales;