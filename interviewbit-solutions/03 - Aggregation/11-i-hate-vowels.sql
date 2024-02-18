-- You are given a ‘Students’ table consisting of Id,Name and marks of two tests namely Marks1 and Marks2. The teacher wants to sort the table based on their marks(in descending order). However the teacher has a particular hate towards students whose Names starts with a vowel. Therefore the teacher would take the maximum of the two tests for students whose name doesn’t start with a vowel while sorting, and would take the minimum of the two tests for the students whose name starts with a vowel while sorting.



-- Solution 1 :

SELECT NAME
FROM   (SELECT   NAME,
                    CASE
                        WHEN Substring(Upper(NAME), 1, 1) IN
                            ( 'A', 'E', 'I', 'O', 'U' ) 
                        THEN Least(Marks1, Marks2)
                        ELSE Greatest(Marks1, Marks2)
                    END AS Marks
        FROM     students
        ORDER BY Marks DESC) AS x 


-- Solution 2: more easier

UPDATE Students
SET    Marks1 = ( CASE
                    WHEN Name REGEXP( "^[aeiou]" ) THEN Least(Marks1, Marks2)
                    ELSE Greatest(Marks1, Marks2)
                  end );

SELECT   Name
FROM     Students
ORDER BY Marks1 DESC; 


-- REMARKS : learnt about GREATEST and LEAST functions. 
-- reference : https://www.databasestar.com/sql-greatest/

-- Differences between the SQL GREATEST and MAX functions:

--  - Both MAX and GREATEST will return one result, but MAX is an aggregate function and GREATEST is not.
--  - GREATEST can return multiple rows. It will return one row for each row of data you query as it is not an aggregate function.

-- So, GREATEST can be used to go across the row, and MAX can be used to go down the columns, or compare values in the same column in different rows.


