WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY continent ORDER BY name) AS rn
    FROM   student
)
SELECT   MIN(CASE WHEN continent='America' THEN name END) AS 'America',
         MIN(CASE WHEN continent='Asia' THEN name END) AS 'Asia',
         MIN(CASE WHEN continent='Europe' THEN name END) AS 'Europe'
FROM     CTE
GROUP BY rn


-- NOTE: relatively easy problem when considering PIVOT problems.