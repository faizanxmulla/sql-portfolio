SELECT   college, 
         COUNT(distinct name) FILTER(WHERE weight < 180 or weight > 250) as n_players
FROM     nfl_combine
GROUP BY college
HAVING   COUNT(distinct name) FILTER(WHERE weight < 180 or weight > 250) > 0



-- NOTE: wasn't using DISTINCT initially