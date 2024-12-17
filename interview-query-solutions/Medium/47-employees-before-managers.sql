SELECT CONCAT(e.first_name, ' ', e.last_name) as employee_name
FROM   employees e JOIN managers m ON e.manager_id=m.id
WHERE  e.join_date < m.join_date



-- NOTE: solved on first attempt