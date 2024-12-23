WITH success_or_not as (
    SELECT ms.message_id, 
           CASE WHEN mr.message_id IS NOT NULL THEN 1 ELSE 0 END as receive_success
    FROM   facebook_messages_sent ms LEFT JOIN facebook_messages_received mr 
    ON     ms.message_id=mr.message_id
)
SELECT 1.0 * SUM(receive_success) / COUNT(receive_success) as ratio
FROM   success_or_not