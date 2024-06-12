SELECT   department,
         PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY salary) AS median_salary
FROM     employee
GROUP BY 1