WITH CTE as (
    SELECT   created_at, COUNT(id) as new_users_added
    FROM     users
    GROUP BY created_at
    ORDER BY created_at
)
SELECT DATE (created_at), 
       SUM(new_users_added) OVER(PARTITION BY EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at) ORDER BY created_at) as monthly_cumulative
FROM   CTE



-- NOTE: solved on second attempt; was missing that the result set required 'date' instead of 'datetime'.