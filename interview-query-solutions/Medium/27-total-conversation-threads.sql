-- Solution 1: using LEAST and GREATEST functions

SELECT COUNT(DISTINCT LEAST(receiver_id, sender_id),
                      GREATEST(receiver_id, sender_id)
            ) as total_conv_threads
FROM   messenger_sends



-- Solution 2: using UNION

WITH all_conversations as (
    SELECT receiver_id as id1, sender_id as id2
    FROM   messenger_sends
    UNION 
    SELECT sender_id as id1, receiver_id as id2
    FROM   messenger_sends
)
SELECT COUNT(*) as total_conv_threads
FROM   all_conversations
WHERE  id1 < id2



-- NOTE: solved in first attempt using solution 1