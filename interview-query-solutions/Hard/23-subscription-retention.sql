WITH cohorts_cte AS (
    SELECT user_id,
           DATE_TRUNC('month', start_date)::date as start_month,
           plan_id,
           CASE 
                WHEN end_date IS NULL THEN 3
                WHEN DATE_PART('month', AGE(end_date, start_date)) >= 2 THEN 3
                WHEN DATE_PART('month', AGE(end_date, start_date)) >= 1 THEN 2
                ELSE 1
           END as retention_months
    FROM   subscriptions
)
,get_retentions_cte as (
    SELECT   start_month,
             plan_id,
             1 as num_month,
             COUNT(*) FILTER (WHERE retention_months >= 1) as retained_users
    FROM     cohorts_cte
    GROUP BY start_month, plan_id
    UNION ALL
    SELECT   start_month,
             plan_id,
             2 as num_month,
             COUNT(*) FILTER (WHERE retention_months >= 2) as retained_users
    FROM     cohort_cte
    GROUP BY start_month, plan_id
    UNION ALL
    SELECT   start_month,
             plan_id,
             3 as num_month,
             COUNT(*) FILTER (WHERE retention_months = 3) as retained_users
    FROM     cohorts_cte
    GROUP BY start_month, plan_id
)
,total_users_cte as (
    SELECT   DATE_TRUNC('month', start_date)::date as start_month,
             plan_id,
             COUNT(*) as total_users
    FROM     subscriptions
    GROUP BY start_month, plan_id
)
SELECT   r.start_month,
         r.num_month,
         r.plan_id,
         ROUND((r.retained_users::decimal / t.total_users), 2) as retained
FROM     get_retentions_cte r JOIN total_users_cte t 
ON       r.start_month = t.start_month and r.plan_id = t.plan_id
ORDER BY r.start_month, r.plan_id, r.num_month





-- NOTE: 

-- couldn't solve any part on my own.
-- also this solution is not 100% correct. doesn't pass the testcases. last row gives incorrect answer.