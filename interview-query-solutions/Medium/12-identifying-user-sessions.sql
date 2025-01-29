WITH sessions_cte AS (
    SELECT   created_at,
	         user_id,
	         event,
             CASE
	              WHEN TIMESTAMPDIFF(MINUTE, LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at DESC), created_at) > 60 
                  OR TIMESTAMPDIFF(MINUTE, LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at DESC), created_at) IS NULL 
	              THEN 1 ELSE 0
             END as is_new_session
    FROM     events 
    ORDER BY user_id, created_at desc
)
SELECT created_at,
       user_id,
       event,
       SUM(is_new_session) OVER(PARTITION BY user_id ORDER BY created_at) as session_id 
FROM   sessions_cte




-- my initial attempt - 

SELECT *, ROW_NUMBER() OVER(PARTITION BY event ORDER BY created_at) as rn
FROM   events e1 JOIN events e2 ON e1.event=e2.event
WHERE  e2.created_at > e1.created_at and 
       e2.created_at - e1.created_at <= INTERVAL '60 minutes' 



