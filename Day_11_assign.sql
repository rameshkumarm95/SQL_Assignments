/*
Ramesh Kumar M
Namaste SQL
25/08/2024
Day 11 Assignment:
*/

-- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.

-- Query
WITH products AS(
SELECT category, product_id, YEAR(order_date) AS years,
MONTH(order_date) AS months, SUM(sales) as total_sales
FROM Orders
GROUP BY category, product_id, YEAR(order_date),MONTH(order_date)
),rolling_3_months AS (
SELECT *, SUM(total_sales) OVER(ORDER BY years,months
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS running_total
FROM products
)
SELECT category, product_id, total_sales, running_total
FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY category ORDER BY
running_total DESC) AS rn
FROM rolling_3_months 
WHERE years = '2020' AND months='01') a
WHERE rn <= 3;

-- write a query to find products for which month over month sales has never declined.

-- Query
WITH products AS (
SELECT product_id, YEAR(order_date) AS years,
MONTH(order_date) AS months, SUM(sales) AS total_sales
FROM Orders
GROUP BY product_id, YEAR(order_date), MONTH(order_date)
), lag_sales AS (
SELECT *, LAG(total_sales,1,0) OVER(PARTITION BY product_id
ORDER BY years,months) AS prev_sales
FROM products
)
SELECT DISTINCT product_id FROM lag_sales
WHERE product_id NOT IN (SELECT product_id FROM lag_sales
WHERE total_sales < prev_sales GROUP BY product_id);


-- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.

-- Query 
WITH categories AS (
SELECT category, YEAR(order_date) AS years,
MONTH(order_date) AS months, ROUND(SUM(sales),2) AS total_sales
FROM Orders
GROUP BY category, YEAR(order_date),MONTH(order_date)
)
SELECT category,years,months, total_sales FROM (
SELECT *, SUM(total_sales) OVER(PARTITION BY category
ORDER BY years,months ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING)
AS combined_sales
FROM categories) a
WHERE total_sales > combined_sales;