-- Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780. Round your answer to  decimal places.


SELECT   ROUND(LONG_W, 4)
FROM     Station
WHERE    LAT_N > 38.7780
ORDER BY LAT_N 
LIMIT    1