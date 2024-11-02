WITH CTE as (
    SELECT date, 
           EXTRACT(MONTH FROM date) as month,
           company_id, 
           call_id
    FROM   rc_calls rc JOIN rc_users ru ON rc.user_id=ru.user_id
    WHERE  date BETWEEN '2020-03-01' and '2020-04-30'
)
SELECT   company_id, 
         COUNT(call_id) FILTER(WHERE month=4) - COUNT(call_id) FILTER(WHERE month=3) as variance
FROM     CTE
GROUP BY 1
ORDER BY 2
LIMIT    1