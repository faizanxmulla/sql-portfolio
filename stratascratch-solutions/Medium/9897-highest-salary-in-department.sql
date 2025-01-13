WITH ranked_salaries as (
    SELECT department,
           first_name as employee_name,
           salary,
           RANK() OVER(PARTITION BY department ORDER BY salary desc) as rn
    FROM   employee
) 
SELECT department, employee_name, salary
FROM   ranked_salaries
WHERE  rn=1