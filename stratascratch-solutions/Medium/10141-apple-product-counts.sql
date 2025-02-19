SELECT   language, 
         COUNT(distinct u.user_id) FILTER(WHERE device IN ('macbook pro', 'iphone 5s', 'ipad air')) as n_apple_users,
         COUNT(distinct u.user_id) as n_total_users
FROM     playbook_events e JOIN playbook_users u ON e.user_id=u.user_id
GROUP BY language
ORDER BY n_total_users desc