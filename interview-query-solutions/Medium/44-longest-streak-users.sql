WITH events_date as (
    SELECT   distinct user_id, created_at::date as visit_date
    FROM     events
    ORDER BY 1, 2
)
, streaks as (
    SELECT distinct user_id,
           visit_date,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY visit_date) as rn
    FROM   events_date
)
,groups as (
    SELECT user_id,
           visit_date,
           visit_date - INTERVAL '1 day' * rn as streak_group
    FROM   streaks
)
,streak_lengths as (
    SELECT   user_id,
             COUNT(*) as streak_length,
             streak_group
    FROM     groups
    GROUP BY user_id, streak_group
)
SELECT   user_id, MAX(streak_length) as streak_length
FROM     streak_lengths
GROUP BY user_id
ORDER BY streak_length desc, user_id
LIMIT    5

