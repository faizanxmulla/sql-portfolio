-- Solution 1: using single CASE WHEN.

WITH CTE AS (
    SELECT CASE
               WHEN jobtitle ILIKE '%police%' THEN 'Police'
               WHEN jobtitle ILIKE '%fire%' THEN 'Firefighter'
               WHEN jobtitle ILIKE '%medical%' THEN 'Medical'
               ELSE NULL
           END AS job_category
    FROM   sf_public_salaries
)
SELECT   job_category as company, COUNT(job_category) AS n_employees
FROM     CTE
WHERE    job_category IS NOT NULL
GROUP BY 1



-- Solution 2: using COUNT(CASE WHEN ...) & UNION ALL

WITH CTE as (
    SELECT 'Police' AS company,
           COUNT(CASE WHEN LOWER(jobtitle) LIKE '%police%' THEN 1 END) AS n_employees
    FROM   sf_public_salaries
    UNION ALL
    SELECT 'Firefighter' AS company,
           COUNT(CASE WHEN LOWER(jobtitle) LIKE '%fire%' THEN 1 END) AS n_employees
    FROM   sf_public_salaries
    UNION ALL
    SELECT 'Medical Staff' AS company,
           COUNT(CASE WHEN LOWER(jobtitle) LIKE '%medical%' THEN 1 END) AS n_employees
    FROM   sf_public_salaries
)
SELECT company, n_employees
FROM   CTE
WHERE  n_employees <> 0