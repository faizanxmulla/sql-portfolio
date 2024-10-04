WITH valid_listens AS (
    SELECT   user_id, song_id, day
    FROM     listens
    GROUP BY 1, 2, 3
),
valid_users AS (
    SELECT   user_id, day
    FROM     valid_listens
    GROUP BY 1, 2
    HAVING   COUNT(song_id) >= 3
),
recommendations_cte AS (
    SELECT   l1.user_id as user_id, l2.user_id as recommended_id, l1.day
    FROM     valid_listens l1 JOIN valid_listens l2 ON l1.user_id < l2.user_id
                                                   AND l1.song_id = l2.song_id
                                                   AND l1.day = l2.day
    GROUP BY 1, 2, 3
    HAVING   COUNT(l1.song_id) >= 3
),
filtered_recommendations AS (
    SELECT r.user_id, r.recommended_id
    FROM   recommendations_cte r LEFT JOIN friendship f 
    ON     (r.user_id = f.user1_id AND r.recommended_id = f.user2_id)
           OR (r.user_id = f.user2_id AND r.recommended_id = f.user1_id)
    WHERE  f.user1_id IS NULL
)
SELECT user_id, recommended_id
FROM   filtered_recommendations
UNION
SELECT recommended_id, user_id
FROM   filtered_recommendations





-- NOTE: 

-- 1. in the filtered recommendations, we can have the WHERE condition using "NOT IN" too instead of the LEFT JOIN and the NULL condition: 
--    WHERE  (rc.user_id, rc.recommended_id) NOT IN (SELECT user1_id, user2_id FROM friendship)