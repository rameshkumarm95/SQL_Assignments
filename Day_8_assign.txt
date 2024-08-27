/*
Ramesh kumar M
NamasteSQL
21/08/2024
Day 8 Assignment
*/

--https://datalemur.com/questions/matching-skills

--Query:
SELECT candidate_id 
FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT skill) >=3
ORDER BY candidate_id ASC;

--https://datalemur.com/questions/sql-page-with-no-likes

--Query:
SELECT p.page_id
FROM pages p LEFT JOIN page_likes pl 
ON p.page_id = pl.page_id
WHERE liked_date IS NULL 
ORDER BY p.page_id;

--https://datalemur.com/questions/tesla-unfinished-parts

--Query:
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

--https://datalemur.com/questions/laptop-mobile-viewership

--Query:
SELECT SUM(CASE WHEN device_type = 'laptop' AND view_time IS NOT NULL THEN 1 ELSE 0 END)
AS laptop_views,
SUM(CASE WHEN device_type IN ('tablet','phone') 
AND view_time IS NOT NULL THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

--https://datalemur.com/questions/sql-average-post-hiatus-1

--Query:
SELECT user_id,
EXTRACT(DAY FROM (MAX(post_date)-MIN(post_date))) AS days_in_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date)='2021'
GROUP BY user_id
HAVING COUNT(user_id)>2;

--https://datalemur.com/questions/teams-power-users

--Query:
SELECT sender_id, COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date)= '08'
AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2;

--https://datalemur.com/questions/completed-trades

--Query:
SELECT u.city, 
SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)
AS total_orders
FROM trades t INNER JOIN users u    
ON u.user_id = t.user_id
GROUP BY u.city
ORDER BY total_orders DESC
LIMIT 3;

--https://datalemur.com/questions/sql-avg-review-ratings

--Query:
SELECT EXTRACT(MONTH FROM submit_date) AS month, product_id
, ROUND(AVG(stars),2)
FROM reviews
GROUP BY month, product_id
ORDER BY month, product_id;

--https://datalemur.com/questions/click-through-rate

--Query:
SELECT app_id,
ROUND(SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)* 100.0/
SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END),2)
AS ctr
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = '2022'
GROUP BY app_id;

--https://datalemur.com/questions/second-day-confirmation
--Query:
SELECT user_id
FROM emails e LEFT JOIN texts t  
ON t.email_id = e.email_id
WHERE EXTRACT(DAY FROM (action_date-signup_date)) =1
AND signup_action = 'Confirmed';

