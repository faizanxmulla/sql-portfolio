-- Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345 . Truncate your answer to  decimal places.

SELECT ROUND(SUM(LAT_N), 4)
FROM   Station
WHERE  LAT_N BETWEEN 38.7880 AND 137.2345
