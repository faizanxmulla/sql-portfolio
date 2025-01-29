-- my solution:

WITH employees_cte as (
    SELECT id
           ,salary
           ,department_id
           ,COUNT(*) OVER(PARTITION BY department_id) as number_of_employees
    FROM   employees
)
SELECT   DISTINCT name as department_name
         ,number_of_employees
         ,1.0 * COUNT(*) FILTER(WHERE salary > 100000) OVER(PARTITION BY department_id) / number_of_employees as percentage_over_100k
FROM     employees_cte e JOIN departments d ON d.id=e.department_id
WHERE    number_of_employees >= 10
ORDER BY 3



-- official solution:

SELECT   d.name as department_name
         ,AVG(CASE WHEN salary > 100000 THEN 1 ELSE 0 END) AS percentage_over_100k
         ,COUNT(*) AS number_of_employees
FROM     departments AS d JOIN employees AS e ON d.id = e.department_id
GROUP BY 1
HAVING   COUNT(*) >= 10
ORDER BY 1 DESC
LIMIT    3




-- NOTE: 

-- solved on own and in first attempt.
-- seeing the solution realized that I did it in a way complicated manner.

-- also, no need to use LEFT JOIN ; if the department has no employees, the condition ‘at least 10 employees’ won’t be satisfied.