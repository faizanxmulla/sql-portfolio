WITH CTE as (
    SELECT p.billing_cycle_in_months,
           EXTRACT(DAY FROM AGE(refunded_at, settled_at)) as days_taken
    FROM   noom_transactions t JOIN noom_signups s ON t.signup_id=s.signup_id
                               JOIN noom_plans p ON s.plan_id=p.plan_id
    WHERE  s.started_at >= '2019-01-01'
)
SELECT   billing_cycle_in_months,
         MIN(days_taken) as min_days,
         AVG(days_taken) as avg_days,
         MAX(days_taken) as max_days
FROM     CTE



-- NOTE: solved on first attempt