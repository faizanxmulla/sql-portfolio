WITH all_users as (
    SELECT day, user1 as users
    FROM   facebook_user_interactions
    UNION ALL
    SELECT day, user2 as users
    FROM   facebook_user_interactions
)
SELECT   day, 
         COUNT(*) / 2 as n_interactions,
         COUNT(distinct users)
FROM     all_users
GROUP BY day