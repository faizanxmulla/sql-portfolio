WITH already_friends AS (
    SELECT friend_id 
    FROM   friends 
    WHERE  user_id=3
),
blocked AS (
    SELECT blocked_id 
    FROM   blocks 
    WHERE  user_id=3
),
liked AS (
    SELECT page_id
    FROM   likes 
    WHERE  user_id=3
),
friend_points AS (
    SELECT   user_id, SUM(3) AS points
    FROM     friends
    WHERE    friend_id IN (SELECT friend_id FROM already_friends)
    GROUP BY 1
),
like_points AS (
    SELECT   user_id, SUM(2) AS points 
    FROM     likes 
    WHERE    page_id IN (SELECT page_id FROM liked)
    GROUP BY 1
)
SELECT u.name AS potential_friend_name, SUM(points) AS friendship_points
FROM (
        SELECT user_id, points 
        FROM   friend_points 
        UNION 
        SELECT user_id, points 
        FROM   like_points 
) f LEFT JOIN users u ON f.user_id = u.user_id
WHERE    u.user_id NOT IN (SELECT friend_id FROM already_friends) AND 
         u.user_id NOT IN (SELECT blocked_id FROM blocked) AND
         u.user_id != 3
GROUP BY 1
ORDER BY 2, 1


