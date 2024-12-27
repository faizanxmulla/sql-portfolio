SELECT   TO_CHAR(created_at, 'YYYY-MM-DD') as dt, 
         1.0 * COUNT(user_id) FILTER(WHERE action='post_submit') / 
               COUNT(user_id) FILTER(WHERE action='post_enter') as post_success_rate
FROM     events
WHERE    created_at BETWEEN '2020-01-01' and '2020-01-31'
GROUP BY created_at



-- NOTE: was very easy after defining 'post_success_rate'