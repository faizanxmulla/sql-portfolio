with ranked_salaries as (
    SELECT d.name as Department, 
           e.name as Employee, 
           e.salary as Salary,
           RANK() OVER(partition by departmentId order by salary desc)
    FROM   Employee e JOIN Department d ON e.departmentId=d.id 
)
SELECT Department, Employee, Salary
FROM   ranked_salaries 
WHERE  rank=1


-- SELECT d.name AS Department, e.name AS Employee, e.salary
-- FROM   Department d JOIN Employee e ON e.departmentId=d.id 
-- WHERE(departmentId, salary) IN
-- (SELECT departmentId,MAX(salary) FROM Employee GROUP BY departmentId) ;