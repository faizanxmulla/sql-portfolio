WITH friends_cte AS (
    SELECT requester_id AS id
    FROM   RequestAccepted
    UNION ALL
    SELECT accepter_id AS id
    FROM   RequestAccepted
)
SELECT   id, COUNT(id) AS num
FROM     friends_cte
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1