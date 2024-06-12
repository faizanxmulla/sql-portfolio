WITH user_event_counts AS (
    SELECT   user_id,
             client_id,
             COUNT(event_id) AS total_events,
             COUNT(CASE WHEN event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent') THEN 1 END) AS relevant_events
    FROM     fact_events
    GROUP BY 1, 2
),
user_relevant_percentage AS (
    SELECT user_id,
           client_id,
           total_events,
           relevant_events,
           (relevant_events::FLOAT / total_events) * 100 AS relevant_percentage
    FROM user_event_counts
)
SELECT   client_id
FROM     user_relevant_percentage
WHERE    relevant_percentage >= 50
ORDER BY relevant_percentage DESC 
LIMIT    1
