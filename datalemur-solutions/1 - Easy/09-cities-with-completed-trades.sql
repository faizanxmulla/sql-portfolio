-- Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.

-- Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. Output the city name and the corresponding number of completed trade orders.


--Solution 1 (also my first approach):

SELECT   u.city, COUNT(t.order_id)
FROM     trades t JOIN users u USING(user_id)
WHERE    t.status='Completed'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    3


-- other approaches : 
-- SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) 