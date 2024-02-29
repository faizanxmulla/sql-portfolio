-- Write a SQL query to find employees who have the highest salary in each of the departments



WITH ranked_salaries as(
    SELECT d.Name as Department, 
           e.Name as Employee, 
           e.Salary, 
           DENSE_RANK() OVER(PARTITION BY d.Name ORDER BY e.Salary desc) as rank
    FROM  Employee e JOIN Department d ON e.DepartmentId=d.Id
)

SELECT   Department as "Department", Employee as "Employee", Salary as "salary"
FROM     ranked_salaries
WHERE    rank=1
ORDER BY 2 DESC



-- remarks: column names are very confusing.