WITH consecutive_groups AS (
    SELECT id, num,
           LAG(num) OVER (ORDER BY id) as prev_num,
           LEAD(num) OVER (ORDER BY id) as next_num,
           LAG(id) OVER () as prev_id,
           LEAD(id) OVER () as next_id
    FROM   Logs
)
SELECT DISTINCT num AS "ConsecutiveNums"
FROM   consecutive_groups
WHERE  num = prev_num AND num = next_num AND
       id+1=next_id AND id-1=prev_id




-- NOTE: 
-- - was making the mistake of doing "ORDER BY num" in the window functions.
-- - also just "ORDER BY id" doesnt work. 
-- - also, in my first attempt tried using both LAG and LEAD functions and using this: num=prev_num and prev_num=next_num which failed 6 of the 23 testcases.
