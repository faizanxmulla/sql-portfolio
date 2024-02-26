-- Write an SQL query to report the distance travelled by each user.

-- Return the result table ordered by travelled_distance in descending order, if two or more users travelled the same distance, order them by their name in ascending order.


SELECT   u.name, 
         CASE WHEN SUM(r.distance) IS NULL THEN 0 ELSE SUM(r.distance) END as travelled_distance
FROM     Users u LEFT JOIN Rides r ON u.id=r.user_id
GROUP BY 1
ORDER BY 2 DESC, 1


-- remarks: solved in first attempt.