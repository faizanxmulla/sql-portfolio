-- Solution 1: using JOIN

SELECT   e.first_name as employee_name, e.salary as employee_salary
FROM     employee e JOIN employee m ON e.manager_id=e.id
WHERE    e.salary > m.salary
GROUP BY e.first_name, e.salary



-- Solution 2: without using JOIN

SELECT first_name as employee_name, salary as employee_salary
FROM   employee
WHERE  salary > (
        SELECT salary
        FROM   employee
        WHERE  id=manager_id
    )