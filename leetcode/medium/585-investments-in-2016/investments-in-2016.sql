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


-- remarks: exact same question in the "Ninjas" section of coding ninjas.