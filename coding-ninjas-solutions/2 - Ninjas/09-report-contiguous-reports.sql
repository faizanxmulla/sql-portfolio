-- A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

-- Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

-- period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

-- Order result by start_date.



WITH cte AS (
    SELECT fail_date AS event_date, 'failed' AS period_state
    FROM   Failed
    WHERE  fail_date BETWEEN '2019-01-01' AND '2019-12-31'
    UNION ALL
    SELECT success_date AS event_date, 'succeeded' AS period_state
    FROM   Succeeded
    WHERE  success_date BETWEEN '2019-01-01' AND '2019-12-31'
)
SELECT 
    period_state,
    MIN(event_date) AS start_date,
    MAX(event_date) AS end_date
FROM (
    SELECT 
        period_state,
        event_date,
        DENSE_RANK() OVER (ORDER BY event_date) - 
        DENSE_RANK() OVER (PARTITION BY period_state ORDER BY event_date) AS grp
    FROM cte
) t
GROUP BY period_state, grp
ORDER BY start_date;



-- remarks: couldn't solve on own. 