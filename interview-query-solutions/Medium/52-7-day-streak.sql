WITH consecutive_visits AS (
    SELECT user_id,
           url,
           created_at AS visit_date,
           ROW_NUMBER() OVER (PARTITION BY user_id, url ORDER BY created_at) AS rn,
           created_at - INTERVAL '1 day' * ROW_NUMBER() OVER (PARTITION BY user_id, url ORDER BY created_at) AS date_offset
    FROM   events
    WHERE  user_id IS NOT NULL AND url IS NOT NULL
)
,streaks AS (
    SELECT   user_id, url, COUNT(*) AS streak_length
    FROM     consecutive_visits
    GROUP BY 1, 2, date_offset
    HAVING   COUNT(*) >= 7
)
SELECT ROUND(COUNT(DISTINCT user_id) / 
             NULLIF((SELECT COUNT(DISTINCT user_id) 
                     FROM   events 
                     WHERE  user_id IS NOT NULL
                ), 0), 2) AS percent_of_users
FROM   streaks



-- my initial approach:

-- SELECT user_id, 
--        url, 
--        created_at as current_date,
--        LEAD(created_at, 1, created_at) OVER(PARTITION BY user_id, url ORDER BY created_at) as next_date, 
--        EXTRACT(EPOCH FROM (LEAD(created_at, 1, created_at) OVER (PARTITION BY user_id, url ORDER BY created_at) - created_at) / 3600) AS date_diff_hrs
-- FROM   events



-- NOTE: 

-- one of the problems where the solution is ingenius; 
-- solution courtesy of "Venkata Naga Sai Kumar Bysani" LinkedIn post.