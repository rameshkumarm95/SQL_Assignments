/*
Ramesh kumar M
NamasteSQL
18/08/2024
Day 6 Assignment
*/

-- write a query to print emp name , their manager name and diffrence in their age (in days) for employees whose year of birth is before their managers year of birth

-- Query:
SELECT e1.emp_name AS employees, e2.emp_name AS managers, 
DATEDIFF(DAY,e1.dob,e2.dob) AS difference_in_their_age
FROM employee e1 INNER JOIN employee e2
ON e1.manager_id = e2.emp_id
WHERE e1.emp_age > e2.emp_age;

-- write a query to find subcategories who never had any return orders in the month of november (irrespective of years)

-- Query:
SELECT o.sub_category
FROM Orders o LEFT JOIN returns$ r
ON r.[Order Id] = o.order_id
WHERE DATENAME(MONTH,order_date) = 'November'
GROUP BY o.sub_category
HAVING COUNT(r.[Order Id]) = 0;

-- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order. write a query to find order ids where there is only 1 product bought by the customer.

-- Query:
SELECT order_id
FROM Orders
GROUP BY order_id
HAVING COUNT(*)=1

-- write a query to print manager names along with the comma separated list(order by emp salary) of all employees directly reporting to him.

-- Query:
SELECT e2.emp_name AS managers, STRING_AGG(e1.emp_name, ' , ')
WITHIN GROUP (ORDER BY e1.salary) AS employees
FROM employee e1 INNER JOIN employee e2
ON e1.manager_id= e2.emp_id
GROUP BY e2.emp_name;

-- write a query to get number of business days between order_date and ship_date (exclude weekends). Assume that all order date and ship date are on weekdays only

-- Query:
SELECT order_id, order_date, ship_date,
DATEDIFF(DAY,order_date, ship_date)-
2*DATEDIFF(WEEK, order_date, ship_date)
AS number_of_business_days
FROM Orders;

-- write a query to print 3 columns : category, total_sales and (total sales of returned orders)

-- Query:
SELECT category, ROUND(SUM(sales),2) AS total_sales,
ROUND(SUM(CASE WHEN r.[Order Id] IS NOT NULL THEN sales
ELSE 0 END),2) AS total_sales_of_returned
FROM Orders o LEFT JOIN returns$ r 
ON r.[Order Id] = o.order_id
GROUP BY category;

-- write a query to print below 3 columns category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)

-- Query:
SELECT category,
SUM(CASE WHEN YEAR(order_date)='2019' THEN sales ELSE 0 END)
AS total_sales_2019,
SUM(CASE WHEN YEAR(order_date)='2020' THEN sales ELSE 0 END)
AS total_sales_2020
FROM Orders
GROUP BY category;

-- write a query print top 5 cities in west region by average no of days between order date and ship date.

-- Query:
SELECT TOP 5 city, 
AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_no_of_days
FROM Orders
WHERE region='West'
GROUP BY city
ORDER BY avg_no_of_days DESC;

-- write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)

-- Query:
SELECT e1.emp_name AS employees, e2.emp_name AS managers, 
e3.emp_name AS senior_managers
FROM employee e1 INNER JOIN employee e2
ON e1.manager_id=e2.emp_id
INNER JOIN employee e3 ON e2.manager_id = e3.emp_id
