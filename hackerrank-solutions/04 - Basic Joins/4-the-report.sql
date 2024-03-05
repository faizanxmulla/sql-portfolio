-- Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8. 

-- The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. 

-- Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order.

-- If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.

-- Write a query to help Eve.



-- Solution 1:

SELECT 
    IF(g.Grade < 8, NULL, s.Name), 
    g.Grade, 
    s.Marks
FROM 
    Students s JOIN Grades g where Marks BETWEEN Min_Mark and Max_Mark 
ORDER BY 
    2 DESC,
    1, 
    3


-- Solution 2:

SELECT   IF(marks > 69, name, NULL),
         IF(marks < 100, Floor(marks/10) + 1, 10) AS grade,
         marks
FROM     Students
ORDER BY 2 DESC,
         1 




-- my approach: should have used IF instead of CASE.

SELECT 
    CASE WHEN g.Grade < '8' THEN s.Name='NULL' ELSE s.Name END , 
    g.Grade, 
    s.Marks
FROM 
    Students s JOIN Grades g where Marks BETWEEN Min_Mark and Max_Mark 
ORDER BY 
    2 DESC,
    1


-- remarks: when thinking of using "CASE WHEN", also see if "IF" can be used instead.