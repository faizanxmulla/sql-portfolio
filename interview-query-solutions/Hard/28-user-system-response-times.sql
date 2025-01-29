WITH response_time_cte AS (
    SELECT i.user_id, 
           cm.message_type, 
           cm.created_at, 
           LAG(cm.created_at) OVER() AS user_response_time
    FROM   conversation_messages cm JOIN interviews i ON i.id = cm.interview_id
)
SELECT   user_id, AVG(TIMESTAMPDIFF(SECOND, user_response_time, created_at)) AS response_times
FROM     response_time_cte
WHERE    message_type = 'user'
GROUP BY 1


-- remarks: 

-- 1. was earlier using the WHERE condition in the CTE itself; leading to incorrect answer. 

-- 2. if using PostgreSQL, we can use : EXTRACT(EPOCH FROM (user_response_time - created_at))

-- 3. also can use LEAD() and then filter by message_type='system'


-- link:  
-- this question is discussed in detail in the following YT video: https://www.youtube.com/watch?v=_iaFt8NqfN4