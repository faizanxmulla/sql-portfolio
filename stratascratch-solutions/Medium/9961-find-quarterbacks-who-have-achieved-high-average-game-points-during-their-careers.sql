SELECT   qb, AVG(game_points) as avg_points
FROM     qbstats_2015_2016
GROUP BY qb
ORDER BY avg_points desc