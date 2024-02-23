-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

-- The column id is continuous increment.
-- Mary wants to change seats for the adjacent students.

-- Can you write a SQL query to output the result for Mary?


SELECT id, 
       COALESCE(CASE WHEN MOD(id, 2) = 0 THEN LAG(student) OVER(ORDER BY id) 
                     WHEN MOD(id, 2) = 1 THEN LEAD(student) OVER(ORDER BY id) END, student) as student
FROM   seat


-- remarks: correctly thought of using LAG and LEAD , but couldnt figure out to use CASE statements like this; also wouldn't be able to think to use 'COALESCE'.