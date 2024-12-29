WITH CTE as (
    SELECT user_id
    FROM   google_friends_network
    UNION ALL 
    SELECT friend_id
    FROM google_friends_network
)
SELECT   user_id
FROM     CTE
GROUP BY user_id
HAVING   COUNT(*) > 3