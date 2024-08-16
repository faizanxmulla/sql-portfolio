WITH CTE AS (
    SELECT user_id, 
           channel, 
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY created_at) as rn,
           SUM(conversion) OVER(PARTITION BY user_id) as conversions
    FROM   user_sessions us JOIN attribution a USING(session_id)
)
SELECT channel, user_id
FROM   CTE
WHERE  rn=1 and conversions <> 0


-- NOTE: 

-- passed the first test case w/o using SUM() window function. then got stuck.
-- earlier was using "WHERE conversion='1' "
