WITH passengers_cte AS (
    SELECT p1.passengerid,
          p1.name,
          ABS(p1.fare - p2.fare) as fare_diff
    FROM   titanic p1 CROSS JOIN titanic p2
    WHERE  p1.passengerid != p2.passengerid AND 
          p1.survived='0' AND p2.survived='0' AND
          p1.pclass=p2.pclass AND 
          p1.age - p2.age <= 5 
)
SELECT   name, AVG(fare_diff) AS avg_abs_fare_diff
FROM     passengers_cte
GROUP BY 1
ORDER BY 1