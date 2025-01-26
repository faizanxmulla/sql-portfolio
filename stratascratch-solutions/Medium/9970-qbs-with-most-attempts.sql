SELECT   qb, SUM(att) as attempts
FROM     qbstats_2015_2016
WHERE    year='2016'
GROUP BY qb
ORDER BY attempts desc