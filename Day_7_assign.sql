/*
Ramesh kumar M
NamasteSQL
20/08/2024
Day 7 Assignment
*/

-- write a query to produce below output from icc_world_cup table.team_name, no_of_matches_played , no_of_wins , no_of_losses

-- Query:
WITH team_win_or_lose AS (
SELECT Team_1 AS team_name, CASE WHEN Team_1 = Winner THEN 1 ELSE 0 END AS win_or_lose
FROM icc_world_cup
UNION ALL
SELECT Team_2, CASE WHEN Team_2 = Winner THEN 1 ELSE 0 END AS win_or_lose
FROM icc_world_cup)
SELECT team_name, COUNT(*) AS no_of_matches_played,
SUM(CASE WHEN win_or_lose = 1 THEN 1 ELSE 0 END) AS 
no_of_wins, SUM(CASE WHEN win_or_lose = 0 THEN 1 ELSE 0
END) AS no_of_losses
FROM team_win_or_lose
GROUP BY team_name;

-- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)

-- Query:
SELECT customer_name,
SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))
AS first_name,
SUBSTRING(customer_name,CHARINDEX(' ',customer_name),
LEN(customer_name)-CHARINDEX(' ',customer_name)+1)
AS last_name
FROM Orders;

-- write a query to print below output using drivers table. Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
id, total_rides , profit_rides
dri_1,5,1
dri_2,2,0

-- Query:
SELECT d1.id, COUNT(*) AS total_rides,
COUNT(d2.id) AS profit_rides
FROM drivers d1
LEFT JOIN drivers d2
ON d1.id=d2.id AND d1.end_loc=d2.start_loc 
AND d1.end_time= d2.start_time
GROUP BY d1.id;

-- write a query to print customer name and no of occurence of character 'n' in the customer name. customer_name , count_of_occurence_of_n

-- Query:
SELECT customer_name,
LEN(customer_name)-LEN(REPLACE(LOWER(customer_name),'n',''))
AS count_of_occurence_of_n
FROM Orders;

-- write a query to print below output from orders data. example output
hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, ,
category, Furniture, ,
category, Office Supplies, ,
sub_category, Art , ,
sub_category, Furnishings, ,
--and so on all the category ,subcategory and ship_mode hierarchies

-- Query:
SELECT 'category' AS hierarchy_type,
category AS hierarchy_name,
SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END)
AS total_sales_in_west_region,
SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END)
AS total_sales_in_east_region
FROM Orders
GROUP BY category
UNION ALL
SELECT 'sub_category' AS hierarchy_type,
sub_category AS hierarchy_name,
SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END)
AS total_sales_in_west_region,
SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END)
AS total_sales_in_east_region
FROM Orders
GROUP BY sub_category
UNION ALL
SELECT 'ship_mode' AS hierarchy_type,
ship_mode AS hierarchy_name,
SUM(CASE WHEN region = 'West' THEN sales ELSE 0 END)
AS total_sales_in_west_region,
SUM(CASE WHEN region = 'East' THEN sales ELSE 0 END)
AS total_sales_in_east_region
FROM Orders
GROUP BY ship_mode;

-- the first 2 characters of order_id represents the country of order placed . write a query to print total no of orders placed in each country
(an order can have 2 rows in the data when more than 1 item was purchased in the order but it should be considered as 1 order)

-- Query:
SELECT LEFT(order_id,2) AS country_of_placed,
COUNT(DISTINCT order_id) AS total_no_of_orders
FROM Orders
GROUP BY LEFT(order_id,2);
