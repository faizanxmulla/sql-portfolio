-- Write an SQL query to find the team size of each of the employees.


SELECT   employee_id, COUNT(employee_id) OVER(PARTITION BY team_id) as team_size
FROM     Employee
ORDER BY 1


-- remarks: 