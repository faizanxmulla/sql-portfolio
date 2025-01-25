SELECT   qb, COUNT(*) as n_appearances
FROM     qbstats_2015_2016
WHERE    year='2016'
GROUP BY qb
ORDER BY n_appearances desc