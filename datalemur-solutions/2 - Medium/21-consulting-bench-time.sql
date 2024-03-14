WITH consulting_days AS (
    SELECT s.employee_id,
           (ce.end_date - ce.start_date) + 1 AS non_bench_days
    FROM   staffing AS s INNER JOIN consulting_engagements AS ce
           ON s.job_id = ce.job_id
    WHERE   s.is_consultant = 'true'
)
SELECT   employee_id,
         365 - SUM(non_bench_days) AS bench_days
FROM     consulting_days
GROUP BY 1