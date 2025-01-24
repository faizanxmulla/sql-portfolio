SELECT   qb, 
         MAX(game_points) FILTER(WHERE home_away='home') as home_points,
         MAX(game_points) FILTER(WHERE home_away='away') as away_points
FROM     qbstats_2015_2016
WHERE    year='2016'
GROUP BY qb