-- Given a table STUDY, update the marks of all the students to 50, whose marks lie in the range 25 - 50 (excluding 25 , including 50 i.e. (25,50] ) . Then print the new table.


UPDATE STUDY 
SET    Marks=50 
WHERE  Marks > 25 and Marks <= 50;

SELECT *
FROM   STUDY;