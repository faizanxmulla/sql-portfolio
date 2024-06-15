SELECT e.employee_id, e.name AS employee_name 
FROM   employee e JOIN employee m ON e.manager_id=m.employee_id
WHERE  e.salary > m.salary