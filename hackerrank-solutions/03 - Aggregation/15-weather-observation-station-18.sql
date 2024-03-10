-- Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.

SELECT Round(Abs(Min(lat_n)-Max(lat_n))
             + Abs(Min(long_w)-Max(long_w)), 4)
FROM   station; 