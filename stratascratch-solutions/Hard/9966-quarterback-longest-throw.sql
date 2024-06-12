WITH adjusted_entries AS (
    SELECT year,
           qb,
           SUBSTRING(lg,'[0-9]+')::INTEGER AS lg
    FROM   qbstats_2015_2016  
)
SELECT   qb, MAX(lg) AS lonegst_throw
FROM     adjusted_entries
WHERE    year=2016
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1