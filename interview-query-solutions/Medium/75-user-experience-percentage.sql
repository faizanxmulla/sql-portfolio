WITH CTE AS (
    SELECT *, LAG(position_name) OVER(PARTITION BY user_id ORDER BY start_date) AS prev_position
    FROM   user_experiences
)
SELECT COUNT(DISTINCT user_id) * 1.0 / (SELECT COUNT(DISTINCT user_id) FROM user_experiences) as percentage
FROM   CTE
WHERE  position_name = 'Data Scientist' AND prev_position = 'Data Analyst'