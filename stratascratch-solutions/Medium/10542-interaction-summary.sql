WITH all_users as (
    SELECT customer_id
    FROM   customer_interactions
    UNION
    SELECT customer_id
    FROM   user_content
)
SELECT   au.customer_id, 
         COUNT(distinct interaction_id) as total_interactions,
         COUNT(distinct content_id) as total_content_items
FROM     all_users au LEFT JOIN customer_interactions ci on au.customer_id = ci.customer_id
                      LEFT JOIN user_content uc on au.customer_id = uc.customer_id
GROUP BY au.customer_id



-- NOTE: coludnt solve on own; didnt realize that I had to create 'all_users'