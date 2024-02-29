-- Given the Employee table, write a SQL query that finds out managers with at least 5 direct report.


-- Solution 1: 

SELECT   Name
FROM     Employee
GROUP BY ManagerId, Name
HAVING   COUNT(ManagerId) >= 5


-- Solution 2: 

SELECT   m.Name
FROM     Employee e JOIN Employee m ON m.Id=e.ManagerId
GROUP BY m.Name
HAVING   COUNT(m.Name) >= 5



