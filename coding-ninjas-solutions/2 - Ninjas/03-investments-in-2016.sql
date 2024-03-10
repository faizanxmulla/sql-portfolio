-- Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

-- - Have the same TIV_2015 value as one or more other policyholders.
-- - Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).


-- Solution 1: using CTE

WITH cte
     AS (SELECT *,
                Concat(lat, ',', lon)
                Count(Concat(lat, ',', lon)) OVER(partition BY Concat(lat, ',', lon)) as coordinates
         FROM   insurance)
SELECT Sum(tiv_2016)
FROM   cte
WHERE  coordinates < 2
       AND tiv_2015 IN (SELECT   tiv_2015
                        FROM     insurance
                        GROUP BY tiv_2015
                        HAVING   Count(tiv_2015) > 1) 



-- Solution 2: using subquery within subquery

SELECT Round(Sum(tiv_2016), 2) AS TIV_2016
FROM   (SELECT tiv_2016
        FROM   insurance
        WHERE  tiv_2015 IN (SELECT tiv_2015
                            FROM   insurance
                            GROUP  BY tiv_2015
                            HAVING Count(*) > 1)
               AND (lat, lon) NOT IN (SELECT    lat,lon
                                       FROM     insurance
                                       GROUP BY 1, 2
                                       HAVING   Count(*) > 1)) AS X; 



-- remarks: was trying a combination of both these approaches and got stuck. 