WITH CTE as (
    SELECT f.user_id, f.friend_id, pl.page_id 
    FROM   friends f JOIN page_likes pl ON f.friend_id = pl.user_id
)
SELECT   c.user_id, 
         c.page_id, 
         COUNT(distinct c.friend_id) as num_friend_likes
FROM     CTE c LEFT JOIN page_likes pl
ON       c.page_id = pl.page_id 
         and c.user_id = pl.user_id
WHERE    pl.user_id IS NULL 
GROUP BY 1, 2



-- NOTE: couldn't solve entirely on own.