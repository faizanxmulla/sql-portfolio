WITH ranked_salaries as (
    SELECT first_name,
           salary,
           RANK() OVER(ORDER BY salary desc) as rn
    FROM   worker
)
SELECT first_name, salary
FROM   ranked_salaries
WHERE  rn=1