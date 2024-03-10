-- Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.


-- Solution 1 : first thought went towards SUBSTR. 

SELECT NAME
FROM STUDENTS 
WHERE Marks > 75
ORDER BY SUBSTR(Name, -3), ID ASC


-- Solution 2 : seems to be the more elegant way.

SELECT NAME
FROM STUDENTS 
WHERE Marks > 75
ORDER BY right(NAME, 3), ID ASC

