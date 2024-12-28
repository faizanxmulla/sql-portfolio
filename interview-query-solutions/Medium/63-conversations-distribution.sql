-- subjective question


WITH base_cte as (
    SELECT id,
           date,
           user1 as main_character,
           user2 as convo_partner,
           msg_count
    FROM   messages
    UNION ALL
    SELECT id,
           date,
           user2,
           user1,
           msg_count
    FROM   messages
)
, filtered_conversations as (
    SELECT   main_character,
             date,
             COUNT(DISTINCT convo_partner) as n_conversations
    FROM     base_cte
    WHERE    date BETWEEN '2020-01-01' AND '2020-12-31'
             and msg_count > 0
    GROUP BY 1, 2
)
SELECT   n_conversations, COUNT(main_character) as n_main_characters
FROM     filtered_conversations
GROUP BY n_conversations
ORDER BY n_conversations