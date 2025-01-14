/*Ramesh kumar M
NamasteSQL
12/08/2024
Day 3 Assignment*/

-- write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

-- Query: 
SELECT * FROM Orders
WHERE customer_name LIKE '_a_d%';

-- write a sql to get all the orders placed in the month of dec 2020 (352 rows)

-- Query:
SELECT * FROM Orders
WHERE order_date BETWEEN '2020-12-01' 
AND '2020-12-31';

-- write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

-- Query:
SELECT * FROM Orders
WHERE ship_mode NOT IN ('Standard Class', 'First Class')
AND ship_date > '2020-11-30';

-- write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

-- Query:
SELECT * FROM Orders
WHERE customer_name NOT LIKE 'A%n';

-- write a query to get all the orders where profit is negative (1871 rows)

-- Query:
SELECT * FROM Orders
WHERE profit LIKE '-%';

-- write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

-- Query:
SELECT * FROM Orders
WHERE quantity < 3 OR profit = 0;

-- your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)

-- Query:
SELECT * FROM Orders 
WHERE region = 'South' AND discount != 0;

-- write a query to find top 5 orders with highest sales in furniture category 

-- Query:
SELECT TOP 5* FROM Orders
WHERE category= 'Furniture'
ORDER BY sales DESC;

-- write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

-- Query:
SELECT * FROM Orders
WHERE category IN ('Technology', 'Furniture')
AND YEAR(order_date) = '2020';

-- write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

-- Query:
SELECT * FROM Orders
WHERE YEAR(order_date) = '2020' 
AND YEAR(ship_date) ='2021';