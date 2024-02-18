-- Given 2 tables EMPLOYEE and EVALUATION, query for the count of names whose Rating is less than 3. Also, query for the count of names whose Rating is greater than 8.


-- Solution 1 : no need to JOIN tables.

SELECT COUNT(*) as 'COUNT(Name)'
FROM   EVALUATION 
WHERE  Rating < 3;

SELECT COUNT(*) as 'COUNT(Name)'
FROM   EVALUATION 
WHERE  Rating > 8;


-- Solution 2 : using JOINS.

SELECT COUNT(Name) 
FROM   EMPLOYEE em INNER JOIN EVALUATION ev ON em.Points BETWEEN ev.Lower AND ev.Upper 
WHERE  ev.Rating < 3;

SELECT COUNT(Name) 
FROM   EMPLOYEE em INNER JOIN EVALUATION ev ON em.Points BETWEEN ev.Lower AND ev.Upper 
WHERE  ev.Rating > 8;


-- remarks : instead of ON, we can also use => WHERE