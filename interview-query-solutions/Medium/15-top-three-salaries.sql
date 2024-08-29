WITH ranked_employees as (
    SELECT department_id
           ,first_name
           ,last_name
           ,salary
           ,RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rank
    FROM   employees
)
SELECT   CONCAT(first_name, ' ', last_name) as employee_name
         ,d.name as department_name
         ,salary
FROM     departments d JOIN ranked_employees re ON d.id = re.department_id
WHERE    rank < 4
ORDER BY 1, 3 DESC