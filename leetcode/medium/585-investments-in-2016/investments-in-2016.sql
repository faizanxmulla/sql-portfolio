WITH CTE AS (
    SELECT *, 
           COUNT(*) OVER(PARTITION BY tiv_2015) as a,
           COUNT(*) OVER(PARTITION BY lat, lon) as b
    FROM   Insurance
)
SELECT ROUND(SUM(tiv_2016)::NUMERIC, 2) as tiv_2016
FROM   CTE
WHERE  a>=2 AND b=1


-- SELECT   tiv_2015, lat, lon
-- FROM     Insurance
-- GROUP BY 1, 2, 3
-- HAVING   COUNT(tiv_2015) >= 2 
