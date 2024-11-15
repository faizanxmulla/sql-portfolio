-- Solution 1: using LEAST and GREATEST window functions


WITH get_conversations as (
    SELECT   LEAST(message_sender_id, message_receiver_id) as user1,
             GREATEST(message_sender_id, message_receiver_id) as user2
    FROM     whatsapp_messages
    GROUP BY 1, 2
)
SELECT COUNT(*) as number_of_conversations
FROM   get_conversations




-- Solution 2: w/o using window functions


WITH get_conversations as (
    SELECT message_sender_id as user1,
           message_receiver_id as user2
    FROM   whatsapp_messages
    UNION 
    SELECT message_receiver_id as user1,
           message_sender_id as user2
    FROM   whatsapp_messages
)
SELECT COUNT(*) as number_of_conversations
FROM   get_conversations
WHERE  user1 < user2



-- NOTE: solved in first attempt