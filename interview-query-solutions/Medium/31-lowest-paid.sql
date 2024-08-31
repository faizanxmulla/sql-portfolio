WITH ranked_employees as (
    SELECT  employee_id, 
            salary,
            RANK() OVER(ORDER BY salary) as rn,
            COUNT(p.id) as completed_projects
    FROM    employees as e JOIN employee_projects as ep ON e.id = ep.employee_id
                           JOIN projects as p ON ep.project_id = p.id
    WHERE    p.end_date IS NOT NULL
    GROUP BY 1, 2
    HAVING   COUNT(p.id) > 1
)
SELECT employee_id, salary, completed_projects 
FROM   ranked_employees 
WHERE  rn <= 3


-- NOTE: easy problem