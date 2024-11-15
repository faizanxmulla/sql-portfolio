SELECT   block_reason, COUNT(DISTINCT user_id) as n_users
FROM     fb_blocked_users
WHERE    block_date BETWEEN '2021-12-01' and '2021-12-31' OR 
         (block_date < '2021-12-01' AND block_duration IS NULL) OR 
         (block_date < '2021-12-01' AND '2021-12-01' <= block_date + block_duration::int)
GROUP BY 1



-- NOTE: couldn't figure out the 3rd condition on my own