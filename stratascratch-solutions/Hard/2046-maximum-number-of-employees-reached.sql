WITH cte as (
    SELECT hire_date as dateaq, 1 as count
    FROM   uber_employees
    UNION ALL 
    SELECT termination_date, -1 as count
    FROM   uber_employees
    WHERE  termination_date IS NOT NULL
)
,sum_cte as (
    SELECT dateaq, SUM(count) OVER(ORDER BY dateaq) as maxemp
    FROM   cte
)
,result_cte as (
    SELECT a.id,
           b.dateaq,
           b.maxemp,
           ROW_NUMBER() OVER (PARTITION BY a.id ORDER BY b.maxemp DESC, b.dateaq) as rn
    FROM   uber_employees a JOIN sum_cte b 
    ON     b.dateaq BETWEEN a.hire_date AND COALESCE(a.termination_date, CURRENT_DATE)
)
SELECT id, maxemp, dateaq
FROM   result_cte
WHERE  rn = 1




-- my initial attempt

SELECT   e1.id, COUNT(e2.id) as max_emp
FROM     uber_employees e1 JOIN uber_employees e2 ON e1.id <> e2.id
WHERE    e1.termination_date > e2.termination_date
         or e2.termination_date IS NULL
GROUP BY 1
ORDER BY 1




-- NOTE: couldn't solve on my own; good problem