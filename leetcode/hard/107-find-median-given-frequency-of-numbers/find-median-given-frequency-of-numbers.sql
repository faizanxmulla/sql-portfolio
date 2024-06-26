WITH CTE AS (
  SELECT *, 
         SUM(frequency) OVER(ORDER BY number) as cumulative_sum,
         (SUM(frequency) OVER() / 2) AS middle_value
  FROM   numbers
)
SELECT ROUND(AVG(number), 4) as median
FROM   CTE
WHERE  middle_value BETWEEN (cumulative_sum - frequency) AND cumulative_sum