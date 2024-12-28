-- Solution 1: using LIMIT

SELECT   sector, AVG(rank) as avg_rank
FROM     forbes_global_2010_2014
WHERE    country='United States'
GROUP BY sector
ORDER BY avg_rank
LIMIT    3



-- Solution 2: using RANK()

WITH ranked_averages as (
    SELECT   sector, 
             AVG(rank) as avg_rank,
             RANK() OVER(ORDER BY AVG(rank)) as rn
    FROM     forbes_global_2010_2014
    WHERE    country='United States'
    GROUP BY sector
)
SELECT sector, avg_rank
FROM   ranked_averages
WHERE  rn <= 3



-- NOTE: 

-- a bit confusing; in the question asking for highest average rank
-- but doesn't work when I "ORDER BY" in descending order