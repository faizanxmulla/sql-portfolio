WITH ranked_salaries as (
    SELECT department,
           CONCAT(first_name, ' ', last_name) as employee_name,
           salary,
           RANK() OVER(PARTITION BY department ORDER BY salary desc) as rn
    FROM   worker
)
SELECT department, employee_name, salary
FROM   ranked_salaries
WHERE  rn=1