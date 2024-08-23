WITH CTE AS (
    SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY created_at) as rank
    FROM   transactions
)
SELECT COUNT(distinct user_id) AS num_of_upsold_customers
FROM   CTE
WHERE  rank > 1