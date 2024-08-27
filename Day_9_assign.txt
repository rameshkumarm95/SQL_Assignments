/*Ramesh kumar M
NamasteSQL
22/08/2024
Day 9 Assignment
*/

--write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.

-- Query
WITH customers AS 
(SELECT customer_id,
COUNT(DISTINCT order_id) AS no_of_orders
FROM Orders
GROUP BY customer_id) 
SELECT customer_id AS premium_customers
FROM customers 
WHERE no_of_orders > (SELECT AVG(no_of_orders)
AS avg_no_of_orders
FROM customers);

-- write a query to find employees whose salary is more than average salary of employees in their department

-- Query
SELECT emp_id, emp_name FROM
(SELECT emp_id, emp_name, salary,
AVG(salary) OVER(PARTITION BY dept_id)
AS avg_salary
FROM employee) a
WHERE salary >  avg_salary;

-- write a query to find employees whose age is more than average age of all the employees.

-- Query
SELECT emp_id, emp_name FROM employee
WHERE emp_age > (SELECT AVG(emp_age) FROM
employee)

-- write a query to print emp name, salary and dep id of highest salaried employee in each department 

-- Query
SELECT emp_name, salary, dept_id
FROM employee
WHERE salary IN (SELECT MAX(salary) OVER(PARTITION BY dept_id)
AS high_salaried FROM employee)

-- write a query to print emp name, salary and dep id of highest salaried overall

-- Query
SELECT emp_name,salary,dept_id
FROM employee
WHERE salary = (SELECT MAX(salary) AS 
high_salaried_overall FROM employee);

--write a query to print product id and total sales of highest selling products (by no of units sold) in each category

-- Query
WITH overall_products AS (
SELECT category,product_id,
SUM(quantity) AS total_qunatity,
SUM(sales) AS total_sales
FROM Orders
GROUP BY category, product_id
), max_quantity AS (
SELECT category, MAX(total_qunatity) AS max_quantities
FROM overall_products
GROUP BY category
)
SELECT o.category,product_id, total_sales
FROM overall_products o INNER JOIN max_quantity m
ON m.category = o.category AND
o.total_qunatity = m.max_quantities;

--https://datalemur.com/questions/signup-confirmation-rate

-- Query
SELECT
ROUND(SUM(CASE WHEN signup_action = 'Confirmed' THEN 1 ELSE 0 END)*1.0/COUNT(*),2)
AS confirm_rate
FROM emails e INNER JOIN texts t ON e.email_id = t.email_id;

--https://datalemur.com/questions/supercloud-customer

-- Query
SELECT customer_id
FROM customer_contracts c INNER JOIN products p
ON p.product_id = c.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) = (SELECT COUNT(DISTINCT product_category)
FROM products);