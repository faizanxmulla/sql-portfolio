WITH combined_corpus AS (
    SELECT fail_date AS event_date, 'failed' AS period_state
    FROM   Failed
    WHERE  fail_date BETWEEN '2019-01-01' AND '2019-12-31'
    UNION ALL
    SELECT success_date AS event_date, 'succeeded' AS period_state
    FROM   Succeeded
    WHERE  success_date BETWEEN '2019-01-01' AND '2019-12-31'
),
get_streaks AS (
    SELECT  period_state,
            event_date,
            DENSE_RANK() OVER(ORDER BY event_date) - 
            DENSE_RANK() OVER(PARTITION BY period_state ORDER BY event_date) AS grp
    FROM    combined_corpus
)
SELECT   period_state,
         MIN(event_date) AS start_date,
         MAX(event_date) AS end_date
FROM     get_streaks
GROUP BY period_state, grp
ORDER BY start_date


-- NOTE: similar to Q9 of Ninjas section of Coding-Ninjas.