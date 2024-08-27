/*
Ramesh kumar M
NamasteSQL
13/08/2024
Day 4 Assignment
*/

-- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

-- Query:
UPDATE Orders
SET city= NULL
WHERE order_id IN ('CA-2020-161389','US-2021-156909');

-- write a query to find orders where city is null (2 rows)

-- Query:
SELECT * FROM Orders
WHERE city IS NULL;

-- write a query to get total profit, first order date and latest order date for each category

-- Query:
SELECT category, SUM(profit) AS total_profit,
MIN(order_date) AS first_order_date
, MAX(order_date) AS latest_order_date
FROM Orders
GROUP BY category;

-- write a query to find sub-categories where average profit is more than the half of the max profit in that sub category

-- Query:
SELECT sub_category
FROM Orders
GROUP BY sub_category 
HAVING AVG(profit) > MAX(profit)/2;

-- create the exams table with below script; create table exams (student_id int, subject varchar(20), marks int);
insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79); write a query to find students who have got same marks in Physics and Chemistry.

-- Query:
SELECT student_id, marks
FROM exams
WHERE subject IN ('Physics','Chemistry')
GROUP BY student_id, marks
HAVING COUNT(*) = 2 AND COUNT(DISTINCT marks)=1;

-- write a query to find total number of products in each category.

-- Query:
SELECT category,COUNT(distinct product_id) AS total_number_of_products
FROM Orders
GROUP BY category;

-- write a query to find top 5 sub categories in west region by total quantity sold

-- Query:
SELECT TOP 5 sub_category, SUM(quantity) AS total_quantity_sold
FROM Orders
WHERE region='West'
GROUP BY sub_category
ORDER BY total_quantity_sold DESC;

-- write a query to find total sales for each region and ship mode combination for orders in year 2020

-- Query: 
SELECT region, SUM(sales) AS total_sales, ship_mode
FROM Orders
WHERE YEAR(order_date) = '2020'
GROUP BY region, ship_mode
ORDER BY total_sales DESC;

