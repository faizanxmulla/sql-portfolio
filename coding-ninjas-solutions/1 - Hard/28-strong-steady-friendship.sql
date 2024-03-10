-- Note that user1_id < user2_id.

-- A friendship between a pair of friends x and y is strong if x and y have at least three common friends.

-- Write an SQL query to find all the strong friendships.
-- Note that the result table should not contain duplicates with user1_id < user2_id.



WITH all_combinations AS (
    SELECT user1_id, user2_id 
    FROM   friendship 
    union all 
    SELECT user2_id, user1_id 
    FROM   friendship)
SELECT   a1.user1_id, a2.user1_id user2_id, count(*) common_friend 
FROM     all_combinations a1 JOIN all_combinations a2 ON a1.user1_id < a2.user1_id AND a1.user2_id = a2.user2_id 
GROUP BY 1, 2 
HAVING   count(*) > 2 
ORDER BY 1, 2



-- remarks: 
-- - couldnt figure out on how to start. 
-- - remember to use: "UNION ALL"
