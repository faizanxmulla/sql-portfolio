SELECT   year, qb, AVG(game_points) as average_points
FROM     qbstats_2015_2016
GROUP BY year, qb
ORDER BY qb, year desc