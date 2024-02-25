-- A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

-- Write an SQL query to find the employees who are high earners in each of the departments.


WITH ranked_salaries as (
    SELECT e.Name AS Employee,
           e.Salary,
           d.Name AS Department, 
           DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary desc) as rank
    FROM   Employee e JOIN Department d ON e.DepartmentId = d.Id
)
SELECT Department, Employee, Salary
FROM   ranked_salaries 
where  rank < 4


-- another approach: close to the solution, j


SELECT d.Name AS Department, e.Name AS Employee, e.Salary
FROM Employee e
INNER JOIN Department d ON e.DepartmentId = d.Id
WHERE e.Salary IN (
  SELECT DISTINCT Salary
  FROM Employee e2
  WHERE e2.DepartmentId = e.DepartmentId
  ORDER BY Salary DESC
  LIMIT 3
);



-- my approach: 


WITH ranked_salaries as (
    SELECT *, DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary) as rank
    FROM   Employee e JOIN Department d USING(Id)
)

SELECT Name as Department, Name as Employee, Salary
FROM   ranked_salaries 
where  rank < 4 



-- remarks: 
-- 1. messed up JOIN by using different common column; 
-- 2. forgot "DESC" in order by. 
