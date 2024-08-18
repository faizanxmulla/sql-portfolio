-- affect of user activity on purchase behaviour

WITH interacting_users AS (
    SELECT DISTINCT user_id
    FROM   events
    WHERE  action IN ('like', 'comment')
)
SELECT   CASE WHEN iu.user_id IS NOT NULL THEN 'Interacting Users' ELSE 'Non-Interacting Users' END AS user_type,
         COUNT(t.user_id) AS number_of_transactions,
         COUNT(DISTINCT t.user_id) AS number_of_users,
         COUNT(t.user_id) * 1.0 / COUNT(DISTINCT t.user_id) AS avg_transactions_per_user
FROM     transactions t LEFT JOIN interacting_users iu ON t.user_id = iu.user_id
GROUP BY 1