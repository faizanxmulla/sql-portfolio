WITH filtered_sessions as (
    SELECT   user_id,
             COUNT(session_type) FILTER(WHERE session_type='streamer') as streaming,
             COUNT(session_type) FILTER(WHERE session_type='viewer') as view
    FROM     twitch_sessions
    GROUP BY 1
    HAVING   COUNT(session_type) FILTER(WHERE session_type='streamer') > 
             COUNT(session_type) FILTER(WHERE session_type='viewer')
),
ranked_filtered_sessions as (
    SELECT *, RANK() OVER(ORDER BY streaming+view desc) as rn
    FROM   filtered_sessions 
)
SELECT user_id, streaming, view
FROM   ranked_filtered_sessions
WHERE  rn <= 10




-- similar approach: this also gives correct answer, but isn't exactly what is asked

SELECT   user_id,
         COUNT(session_type) FILTER(WHERE session_type='streamer') as streaming,
         COUNT(session_type) FILTER(WHERE session_type='viewer') as view
FROM     twitch_sessions
GROUP BY 1
HAVING   COUNT(session_type) FILTER(WHERE session_type='streamer') > 
         COUNT(session_type) FILTER(WHERE session_type='viewer')