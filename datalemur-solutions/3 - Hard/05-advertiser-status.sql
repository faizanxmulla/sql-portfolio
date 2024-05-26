-- Solution 1: 

SELECT   COALESCE(a.user_id, dp.user_id) AS user_id,
         CASE 
              WHEN paid IS NULL THEN 'CHURN' 
              WHEN paid IS NOT NULL AND a.status IN ('NEW','EXISTING','RESURRECT') THEN 'EXISTING'
              WHEN paid IS NOT NULL AND a.status = 'CHURN' THEN 'RESURRECT'
              WHEN paid IS NOT NULL AND a.status IS NULL THEN 'NEW'
         END AS new_status
FROM     advertiser a FULL OUTER JOIN daily_pay dp USING(user_id)
ORDER BY 1