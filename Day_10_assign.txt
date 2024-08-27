/*
Ramesh kumar M
namasteSQL
23/08/2024
Day 10 Assignment
*/

-- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
--In case a department has less than 3 employees then print the details of highest salaried employee in that department
use [namastesq;];
-- Query
WITH rd_highest_salaried AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC)
AS rn,
COUNT(*) OVER(PARTITION BY dept_id) AS no_of_emp
FROM employee
)
SELECT *
FROM rd_highest_salaried
WHERE rn = 3 OR (no_of_emp<3 AND rn = 1);


-- write a query to find top 3 and bottom 3 products by sales in each region.

-- Query
WITH product_region_sales AS (
SELECT region, product_id, SUM(sales) AS total_sales
FROM Orders
GROUP BY region, product_id
), product_lists AS (
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY region
ORDER BY total_sales DESC) AS top_3,
ROW_NUMBER() OVER(PARTITION BY region
ORDER BY total_sales ASC) AS bottom_3
FROM product_region_sales
)
SELECT region,product_id,total_sales
, 'top_3' AS rankings
FROM product_lists
WHERE top_3 <= 3
UNION ALL
SELECT region,product_id,total_sales
, 'bottom_3' AS rankings
FROM product_lists
WHERE bottom_3 <= 3
ORDER BY region, total_sales DESC;


-- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.

-- Query
WITH sub_sales AS (
SELECT sub_category, YEAR(order_date) AS years, 
MONTH(order_date) AS months,SUM(sales) AS total_sales
FROM Orders
GROUP BY sub_category, YEAR(order_date), MONTH(order_date)
), lag_sales AS (
SELECT *, LAG(total_sales) OVER(PARTITION BY sub_category
ORDER BY years,months) AS prev_sales
FROM sub_sales
)
SELECT TOP 1 * FROM (SELECT sub_category, total_sales-prev_sales/prev_sales
AS month_over_month_growth
FROM lag_sales
WHERE years='2020' AND months='01') a
ORDER BY month_over_month_growth DESC;


-- write a query to print top 3 products in each category by year over year sales growth in year 2020.

-- Query 
WITH cat_sales AS (
SELECT category,product_id, YEAR(order_date) AS years, 
MONTH(order_date) AS months,SUM(sales) AS total_sales
FROM Orders
GROUP BY category,product_id, YEAR(order_date), MONTH(order_date)
), lag_sales AS (
SELECT *, LAG(total_sales) OVER(PARTITION BY category
ORDER BY years,months) AS prev_sales
FROM cat_sales
)
SELECT category,product_id,year_over_year_growth FROM (
SELECT category,product_id, total_sales-prev_sales/prev_sales
AS year_over_year_growth,
ROW_NUMBER() OVER(PARTITION BY category
ORDER BY years,months) AS rn
FROM lag_sales
WHERE years='2020') A
WHERE rn <= 3
ORDER BY category,year_over_year_growth DESC;


-- write a query to get start time and end time of each call from above 2 tables.Also create a column of call duration in minutes.  Please do take into account that
-- there will be multiple calls from one phone number and each entry in start table has a corresponding entry in end table.

-- Query
SELECT s.phone_number, s.start_time, e.end_time, 
DATEDIFF(MINUTE,s.start_time,e.end_time) AS duration
FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY phone_number
ORDER BY start_time) AS rn
FROM call_start_logs) s 
INNER JOIN 
(SELECT *, ROW_NUMBER() OVER(PARTITION BY phone_number
ORDER BY end_time) AS rn 
FROM call_end_logs) e ON e.phone_number =
s.phone_number AND s.rn = e.rn;


--https://datalemur.com/questions/top-fans-rank

-- Query
SELECT * FROM (SELECT artist_name, 
DENSE_RANK() OVER(ORDER BY COUNT(g.song_id) DESC)
AS artist_rank
FROM artists a INNER JOIN songs s ON s.artist_id = a.artist_id
INNER JOIN global_song_rank g ON g.song_id = s.song_id
WHERE g.rank <= 10
GROUP BY 1) a
WHERE artist_rank <= 5;

--https://datalemur.com/questions/sql-highest-grossing

-- Query
WITH products AS (
SELECT category, product,SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)= 2022
GROUP BY category, product
)
SELECT category, product, total_spend FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rn
FROM products) a
WHERE rn <=2;

--https://datalemur.com/questions/yoy-growth-rate

-- Query
WITH products AS (
SELECT product_id, EXTRACT(YEAR FROM transaction_date) AS year,
EXTRACT(MONTH FROM transaction_date) AS month, SUM(spend) AS curr_year_spend
FROM user_transactions
GROUP BY product_id, EXTRACT(YEAR FROM transaction_date),EXTRACT(MONTH FROM transaction_date)
), lag_sales AS (
SELECT *, LAG(curr_year_spend,1) OVER(PARTITION BY product_id ORDER BY year,month)
AS prev_year_spend FROM products
)
SELECT year, product_id, curr_year_spend, prev_year_spend, yoy_rate FROM (
SELECT *, ROUND(100*(curr_year_spend-prev_year_spend)*1.0/prev_year_spend,2) AS yoy_rate
FROM lag_sales) a
