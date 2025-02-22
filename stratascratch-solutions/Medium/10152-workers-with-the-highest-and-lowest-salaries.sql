WITH ranked_salaries as (
    SELECT worker_id, 
           salary, 
           department, 
           RANK() OVER(ORDER BY salary desc) as highest_rn,
           RANK() OVER(ORDER BY salary) as lowest_rn
    FROM   worker
)
SELECT worker_id, salary, department, 'Lowest Salary' as salary_type
FROM   ranked_salaries
WHERE  lowest_rn=1
UNION
SELECT worker_id, salary, department, 'Highest Salary' as salary_type
FROM   ranked_salaries
WHERE  highest_rn=1