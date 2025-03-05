WITH cte as (
    SELECT   user_id, 
             MAX(timestamp) FILTER(WHERE action='page_load') as latest_page_load, 
             MIN(timestamp) FILTER(WHERE action='page_exit') as earliest_page_exit
    FROM     facebook_web_log
    GROUP BY user_id, date(timestamp)
    ORDER BY user_id, date(timestamp)
)
SELECT   user_id, AVG(earliest_page_exit - latest_page_load) as avg_session_duration
FROM     cte
WHERE    earliest_page_exit > latest_page_load
GROUP BY user_id



-- NOTE: solved on first attempt