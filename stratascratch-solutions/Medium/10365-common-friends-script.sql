-- Solution 1: using INTERSECT

SELECT user_id, user_name
FROM   users
WHERE  user_id IN (
    SELECT friend_id as user_id
    FROM   users u1 JOIN friends f1 ON f1.user_id = u1.user_id
    WHERE  u1.user_name = 'Karl'
    INTERSECT
    SELECT friend_id as user_id
    FROM   users u2 JOIN friends f2 ON f2.user_id = u2.user_id
    WHERE  u2.user_name = 'Hans'
)


-- Solution 2: using GROUP BY / HAVING

SELECT  u.user_id, u.user_name
FROM    users u JOIN friends f ON u.user_id=f.friend_id
WHERE   f.user_id IN (
    SELECT user_id 
    FROM   users 
    WHERE  user_name IN ('Karl', 'Hans')
)
GROUP BY u.user_id, u.user_name
HAVING   COUNT(DISTINCT f.user_id) = 2