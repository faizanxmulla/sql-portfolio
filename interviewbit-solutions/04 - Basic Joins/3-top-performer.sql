-- Given 2 tables EMPLOYEE and EVALUATION, build a report containing the 2 columns, Name and Rating. Employees with Ratings less than 6 should appear as NULL in the table. T

-- The entries in the table should be sorted by descending order of Rating, followed by Names in lexicographic order.


-- Solution 1 : using CASE (my first approach)

SELECT   CASE WHEN Rating >=6 THEN Name ELSE 'NULL' END as Names, Rating
FROM     EMPLOYEE em INNER JOIN EVALUATION ev ON em.Points BETWEEN ev.Lower AND ev.Upper 
ORDER BY Rating DESC, Name 


-- Solution 2: using IF (seems more clean)

SELECT   IF(Rating >= 6, Name, NULL) as Names, Rating
FROM     EMPLOYEE em INNER JOIN EVALUATION ev ON em.Points BETWEEN ev.Lower AND ev.Upper 
ORDER BY Rating DESC, Name 



-- remarks : instead of ON, we can also use => WHERE