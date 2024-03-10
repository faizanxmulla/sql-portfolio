-- Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. 
-- It should not recommend pages you already liked.

-- Return result table in any order without duplicates.



WITH cte as(
         SELECT user1_id,user2_id
         FROM   friendship
         WHERE  user1_id = 1 OR user2_id = 1),
     cteb AS (
         SELECT user1_id
         FROM   cte
         WHERE  user1_id NOT IN ( 1 )
         UNION
         SELECT user2_id
         FROM   cte
         WHERE  user2_id NOT IN ( 1 ))
SELECT DISTINCT page_id AS recommended_page
FROM   likes
WHERE  user_id IN (SELECT *
                   FROM   cteb)
       AND page_id NOT IN (SELECT page_id
                           FROM   likes
                           WHERE  user_id = 1)
ORDER BY 1



-- another approach: 

WITH nu AS (
    SELECT 
         CASE
             WHEN user1_id = 1 THEN user2_id
             WHEN user2_id = 1 THEN user1_id
         ELSE 1  
         END AS user_id
    FROM friendship
)
,mu as(
    select user_id,page_id
    from likes
    where user_id = 1
)
SELECT distinct page_id as recommended_page
from   likes 
where  page_id not in (
        select page_id
        from mu) and 
       user_id in (
        select user_id 
        from nu)