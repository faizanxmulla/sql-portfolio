-- You are given a table ‘Students’ which consists of the marks that students from different classes obtained in the final exam. Write an SQL query to find for each departments the number of students who managed to score above total average (average considering students of all classes) . The output should be sorted by ClassId .


SELECT Count(Id) AS A
FROM   Students
WHERE  Marks > (SELECT Avg(Marks)
                FROM   students)
GROUP BY ClassId
ORDER BY ClassId 



-- my initial approach: 

WHERE   Marks > Avg(Marks) --- or --- 
HAVING  Marks > Avg(Marks)

-- this lead to following error : "Unknown column 'Marks' in 'having clause'"

-- Explanation : The error message "Unknown column 'Marks' in 'having clause'" indicates that the column 'Marks' is not recognized within the `HAVING` clause. This error commonly occurs because columns referenced in the `HAVING` clause must be derived from an aggregate function or be included in the `GROUP BY` clause.
