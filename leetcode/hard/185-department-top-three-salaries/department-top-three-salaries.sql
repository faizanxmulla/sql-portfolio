with ranked_salaries as (
    SELECT d.name as Department, 
           e.name as Employee, 
           e.Salary as Salary,
           DENSE_RANK() OVER(partition by d.name ORDER BY e.salary desc) as rn
    FROM   Employee e JOIN Department d ON d.id=e.departmentId
)
SELECT Department, Employee, Salary
FROM   ranked_salaries
WHERE  rn <= 3


-- remarks: did not use "ORDER BY desc" and was stuck there. also initially, didn't use DENSE_RANK instead of RANK.