-- You are given a table ‘Students’ which consists of the student information of every student along with the marks that they obtained in a test out of 100. However there were students who were Absent for the test, their marks section would contain ‘Absent’ word. 

-- Help the teacher arrange the students first based on their marks and second based on their first name.(You just have to output the names of the students).



-- Solution 1 : learnt something new ==> usage of CASE in ORDER BY function. 

SELECT   NAME
FROM     students
ORDER BY CASE
            WHEN Marks = 'Absent' THEN 1
            ELSE 0
          END,
          Marks DESC,
          NAME;


-- Solution 2 : similar to 1. 
SELECT   NAME
FROM     (SELECT NAME,
               Marks,
               ( CASE
                   WHEN Marks = “Absent” THEN 0
                   ELSE 1
                 END ) AS ab
          FROM   students) AS x
ORDER BY ab DESC,
         marks DESC,
         NAME;


-- Solution 3: 

UPDATE Students
SET    Marks = -1
WHERE  Marks = 'Absent';

SELECT   Name
FROM     Students
ORDER BY Marks DESC,
         Name ; 



-- Solution approach:

-- We can create another table having the same coloumn as that of Students table with one extra coloumn ‘is_absent’ which has value 1 if the student is not absent otherwise 0.

-- We can order this new table based on is_absent(in descending order),Marks(in descending order) and Name(in ascending order).


-- my first approach : 
SELECT GREATEST(Marks, Name) as Name
FROM Students