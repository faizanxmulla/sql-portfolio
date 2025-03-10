WITH ranked_salaries as (
    SELECT department, 
           employee_id, 
           salary, 
           DENSE_RANK() OVER(PARTITION BY department ORDER BY salary desc) as rn
    FROM   employee_data
)
SELECT department, employee_id, salary as second_highest_salary
FROM   ranked_salaries
WHERE  rn=2