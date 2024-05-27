-- pop. percentage = 100.0 * total friends / total users

WITH pool as (
    SELECT * 
    FROM   facebook_friends
    UNION
    SELECT user2, user1 
    FROM   facebook_friends
),
total as (
    SELECT COUNT(*) as cnt
    FROM   facebook_friends
)
SELECT   user1, 
         (100 * COUNT(*) / MIN(cnt)::float) as pnt
FROM     pool, total
GROUP BY 1
ORDER BY 2 DESC