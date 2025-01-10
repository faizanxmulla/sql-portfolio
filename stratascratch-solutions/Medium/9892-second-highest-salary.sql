WITH ranked_salaries as (
    SELECT salary, DENSE_RANK() OVER(ORDER BY salary desc) as rn
    FROM   employee
)
SELECT salary
FROM   ranked_salaries
WHERE  rn=2