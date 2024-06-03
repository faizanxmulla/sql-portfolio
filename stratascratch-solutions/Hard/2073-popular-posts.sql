WITH session_time_cte AS (
    SELECT   session_id, 
             EXTRACT(EPOCH FROM session_endtime - session_starttime) as session_time
    FROM     user_sessions
)
SELECT   post_id, (SUM(session_time * perc_viewed) / 100) AS post_view_time
FROM     session_time_cte sc JOIN post_views pv USING(session_id)
GROUP BY 1
HAVING   (SUM(session_time * perc_viewed) / 100) > 5 