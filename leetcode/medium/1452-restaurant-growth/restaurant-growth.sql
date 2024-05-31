WITH CTE AS (
SELECT   visited_on,
         SUM(amount) OVER wdw as amount,
         ROUND((SUM(amount) OVER wdw)::NUMERIC / 7, 2) AS average_amount
FROM     Customer
         WINDOW wdw AS (ORDER BY visited_on 
                        RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW)
)
SELECT   DISTINCT *
FROM     CTE 
WHERE    visited_on - (SELECT MIN(visited_on) FROM CTE) > 5
ORDER BY 1