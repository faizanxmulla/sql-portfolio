-- approach 1: 

SELECT 1.0 * COUNT(user_id) FILTER(WHERE status='open'and country='USA') / 
             COUNT(user_id) AS active_users_share
FROM   fb_active_users


-- approach 2: 

SELECT 1.0 * COUNT(user_id) / (SELECT COUNT(*) FROM fb_active_users) as active_users_share
FROM   fb_active_users
WHERE  status='open' and country='USA'



-- note: also in approach 1, we can use COUNT(CASE WHEN ...) instead of COUNT() FILTER(WHERE ...)