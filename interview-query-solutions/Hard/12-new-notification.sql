SELECT   TO_CHAR(e.created_at, 'YYYY-MM') as year_month,
         v.variant,
         COUNT(CASE WHEN e.action = 'login' THEN e.user_id END) as login_users,
         COUNT(CASE WHEN e.action = 'nologin' THEN e.user_id END) as nologin_users,
         COUNT(CASE WHEN e.action = 'unsubscribe' THEN e.user_id END) as unsubscribe_users
FROM     events e JOIN variants v USING (user_id)
GROUP BY 1, 2
ORDER BY 1


-- note: can't test solution, so not 100% percent sure if it is what was expected.