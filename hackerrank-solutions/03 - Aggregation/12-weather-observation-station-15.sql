-- Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345 . Truncate your answer to  decimal places.

SELECT   ROUND(LONG_W, 4)
FROM     Station
WHERE    LAT_N < 137.2345
ORDER BY LAT_N DESC
LIMIT    1