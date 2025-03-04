WITH ranked_users as (
    SELECT   user_id, 
             name, 
             SUM(distance) as traveled_distance, 
             DENSE_RANK() OVER(ORDER BY SUM(distance) desc) as rn
    FROM     lyft_rides_log rl JOIN lyft_users u ON rl.user_id=u.id
    GROUP BY user_id, name
)
SELECT user_id, name, traveled_distance
FROM   ranked_users
WHERE  rn < 10