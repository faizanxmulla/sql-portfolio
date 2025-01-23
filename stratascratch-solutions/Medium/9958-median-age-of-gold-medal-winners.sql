-- Solution 1: using PERCENTILE_CONT()

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY age) as median
FROM   olympics_athletes_events
WHERE  medal='Gold'



-- Solution 2: w/o using PERCENTILE_CONT()

WITH CTE as (
    SELECT age,
           ROW_NUMBER() OVER (ORDER BY age) as rn,
           COUNT(*) OVER () as total_rows
    FROM   olympics_athletes_events
)
SELECT AVG(age) as median
FROM   CTE
WHERE  rn in ((total_rows + 1) / 2, (total_rows + 2) / 2)