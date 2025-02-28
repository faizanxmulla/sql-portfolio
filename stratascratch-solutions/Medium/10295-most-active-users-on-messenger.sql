WITH all_messages as (
    SELECT user1 as username, msg_count
    FROM   fb_messages
    UNION ALL
    SELECT user2, msg_count
    FROM   fb_messages
)
, ranked_users as (
    SELECT   username, 
             SUM(msg_count) as total_msg_count,
             RANK() OVER(ORDER BY SUM(msg_count) desc) as rn
    FROM     all_messages
    GROUP BY username
)
SELECT username, total_msg_count
FROM   ranked_users
WHERE  rn <= 10