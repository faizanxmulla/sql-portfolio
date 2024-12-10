WITH views_within_7_days AS (
    SELECT   el.user_id
    FROM     pins p JOIN event_log el ON p.pin_id = el.pin_id
    WHERE    el.action_type = 'View'
             and el.action_date <= p.created_at + INTERVAL '7 days'
    GROUP BY user_id
)
,engaged_users as (
    SELECT   user_id
    FROM     event_log
    WHERE    action_type = 'Engagement'
    GROUP BY user_id
)
,eligible_users as (
    SELECT   v.user_id
    FROM     views_within_7_days v JOIN engaged_users e ON v.user_id = e.user_id
    GROUP BY v.user_id
)
SELECT COUNT(distinct eu.user_id)::float / COUNT(distinct el.user_id)::float as percent_of_users
FROM   event_log el LEFT JOIN eligible_users eu ON el.user_id = eu.user_id




-- my initial attempt

SELECT COUNT(user_id) FILTER(WHERE action_type='View' and action_date - created_at <= INTERVAL '7 days'),
       COUNT(user_id) FILTER(WHERE action_type='Engagement')
FROM   pins p JOIN event_log el ON p.pin_id=el.pin_id