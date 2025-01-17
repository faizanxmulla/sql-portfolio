-- Solution 1: using FILTER clause

SELECT   department,
         COUNT(id) FILTER(WHERE sex='F') as females,
         SUM(salary) FILTER(WHERE sex='F') as fem_sal,
         COUNT(id) FILTER(WHERE sex='M') as males,
         SUM(salary) FILTER(WHERE sex='M') as mal_sal
FROM     employee
GROUP BY department



-- Solution 2: without using FILTER clause

WITH female_metrics as (
    SELECT   department, COUNT(id) as females, SUM(salary) as fem_sal
    FROM     employee
    WHERE    sex='F'
    GROUP BY department
)
,male_metrics as (
    SELECT   department, COUNT(id) as males, SUM(salary) as mal_sal
    FROM     employee
    WHERE    sex='M'
    GROUP BY department
)
SELECT fm.department, females, fem_sal, males, mal_sal
FROM   female_metrics fm JOIN male_metrics mm ON fm.department=mm.department