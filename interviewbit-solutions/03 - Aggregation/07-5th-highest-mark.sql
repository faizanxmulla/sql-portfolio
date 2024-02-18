-- Given the ‘STUDENTS’ table. Write an SQL query to find the 5’th highest marks in the students table.

SELECT   MARKS
FROM     STUDENTS
ORDER BY 1 DESC 
LIMIT    1
OFFSET   4


-- other approaches :

SELECT MARKS
FROM   (
        SELECT * , RANK() OVER(ORDER BY MARKS DESC) AS rank
        FROM STUDENTS
        ) AS x
WHERE  rank=5


-- remarks : to remember --> asked many times in interview.


