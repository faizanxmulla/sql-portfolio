-- Given 2 tables ‘Students’ and ‘Departments’. Write an SQL query to find the students who has the Lowest GPA in each of the departments. 


SELECT   Concat(d.DepartmentName, ',', s.name, ',', s.GPA) AS A
FROM     Students s
         JOIN departments d USING(Departmentid)
WHERE    GPA IN (SELECT   Min(GPA)
                 FROM     Students
                 GROUP BY Departmentid)
ORDER BY DepartmentName 



-- remarks : try not to solve the entire thing at once. solve it step-by-step by seeing the O/P at each step.