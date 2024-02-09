-- Query the Euclidean Distance between points P1 and P2 and round it to a scale of 4 decimal places.

SELECT Round(Sqrt(Power(Max(lat_n) - Min(lat_n), 2)
                  + Power(Max(long_w) - Min(long_w), 2)), 4)
FROM   station; 