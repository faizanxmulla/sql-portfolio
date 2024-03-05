-- Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than . Truncate your answer to  decimal places.

SELECT ROUND(MAX(LAT_N), 4)
FROM   Station
WHERE  LAT_N < 137.2345