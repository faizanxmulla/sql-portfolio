WITH ranked_calls as (
    SELECT   ru.company_id, 
             rc.user_id, 
             DENSE_RANK() OVER(PARTITION BY ru.company_id ORDER BY COUNT(call_id) desc) as rank
    FROM     rc_calls rc JOIN rc_users ru ON rc.user_id=ru.user_id
    GROUP BY 1, 2
)
SELECT *
FROM   ranked_calls
WHERE  rank < 3