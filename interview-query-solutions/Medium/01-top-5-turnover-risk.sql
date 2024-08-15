SELECT   employee_id
FROM     employees e JOIN projects p ON e.id=p.employee_id
GROUP BY 1
HAVING   COUNT(End_dt) >= 3
ORDER BY salary 
LIMIT    5


-- note: easy solution using limit, but can also be solved using RANK() in PostgreSQL.