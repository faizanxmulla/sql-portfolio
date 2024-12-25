WITH CTE as (
    SELECT   user_id
    FROM     events
    WHERE    action in ('like','comment')
    GROUP BY user_id
)
SELECT ROUND(1.0 * SUM(CASE WHEN c.user_id IS NULL THEN 1 ELSE 0 END) / COUNT(u.id), 2) as percent_never
FROM   users u LEFT JOIN CTE c ON u.id = c.user_id



-- my initial attempt:

-- SELECT ROUND(100.0 * COUNT(user_id) / (SELECT COUNT(user_id) FROM users), 2) as percent_never
-- FROM   events
-- WHERE  action NOT IN ('like', 'comment')