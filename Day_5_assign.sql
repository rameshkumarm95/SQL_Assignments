/*
Ramesh kumar M
NamasteSQL
15/08/2024
Day 5 Assignment
*/

-- write a query to get region wise count of return orders

-- Query:
SELECT o.region, COUNT(DISTINCT o.order_id) 
AS count_of_return_orders
FROM Orders o
INNER JOIN returns$ r ON r.[Order Id]= o.order_id
GROUP BY region;

-- write a query to get category wise sales of orders that were not returned

-- Query:
SELECT category, ROUND(SUM(CASE WHEN r.[Order Id] IS NULL
THEN sales ELSE 0 END),2) AS total_sales
FROM Orders o LEFT JOIN returns$ r
ON r.[Order Id] = o.order_id
GROUP BY category;

-- write a query to print dep name and average salary of employees in that dep .

-- Query:
SELECT d.dep_name,AVG(e.salary) AS avg_salary_of_employees
FROM employee e INNER JOIN dept d
ON d.dep_id = e.dept_id
GROUP BY d.dep_name;

-- write a query to print dep names where none of the emplyees have same salary.

-- Query:
SELECT d.dep_name
FROM employee e INNER JOIN dept d
ON d.dep_id = e.dept_id
GROUP BY d.dep_name
HAVING COUNT(DISTINCT e.salary) = COUNT(e.emp_id);

-- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

-- Query:
SELECT sub_category
FROM Orders o INNER JOIN returns$ r
ON r.[Order Id] = o.order_id
GROUP BY sub_category
HAVING COUNT(DISTINCT r.[Return Reason]) = 3;

-- write a query to find cities where not even a single order was returned.

-- Query:
SELECT o.city FROM Orders o 
LEFT JOIN returns$ r
ON r.[Order Id] = o.order_id
GROUP BY city
HAVING COUNT(r.[Order Id])=0;

-- write a query to find top 3 subcategories by sales of returned orders in east region

-- Query:
SELECT TOP 3 o.sub_category, SUM(sales) AS return_sales
FROM Orders o INNER JOIN returns$ r
ON r.[Order Id] = o.order_id
WHERE region='East'
GROUP BY sub_category
ORDER BY return_sales DESC;

-- write a query to print dep name for which there is no employee

-- Query:
SELECT d.dep_name
FROM dept d LEFT JOIN employee e 
ON e.dept_id = d.dep_id
GROUP BY d.dep_name
HAVING COUNT(e.emp_id) = 0;

-- write a query to print employees name for dep id is not avaiable in dept table

-- Query:
SELECT e.emp_name
FROM employee e LEFT JOIN dept d
ON d.dep_id = e.dept_id
WHERE dep_id IS NULL;


