-- Given a table Students. Write an SQL qurey to find for all students the marks which are immediately greater than the student’s marks . The output should have 1 column ‘Next’ and should contain the marks which are immediately greater than the student’s marks for each student which are Sorted by their Name.


SELECT   LEAD(Marks) OVER (ORDER BY MARKS) as Next
FROM     Students
ORDER BY Name



-- REMARKS : learnt about LEAD window function.
-- also this query doesnt work in case of Duplicate marks.

-- reference link : https://www.sqltutorial.org/sql-window-functions/sql-lead/