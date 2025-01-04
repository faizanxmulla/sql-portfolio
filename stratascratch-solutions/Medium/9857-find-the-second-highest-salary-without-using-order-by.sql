-- Solution 1: using DENSE_RANK() window function

WITH ranked_salaries as (
    SELECT salary, DENSE_RANK() OVER(ORDER BY salary desc) as rn
    FROM   worker
)
SELECT salary 
FROM   ranked_salaries
WHERE  rn=2



-- Solution 2: using MAX()

SELECT MAX(salary) 
FROM   worker
WHERE  salary NOT IN (
    SELECT MAX(salary)
    FROM   worker
)