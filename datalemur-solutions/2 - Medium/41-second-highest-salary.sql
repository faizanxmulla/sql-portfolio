WITH ranked_salaries AS (
    SELECT *, RANK() OVER(ORDER BY salary DESC)
    FROM   employees
)
SELECT salary as second_highest_salary
FROM   ranked_salaries 
WHERE  rank=2