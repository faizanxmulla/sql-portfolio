SELECT   year, COUNT(name) as n_players
FROM     nfl_combine
GROUP BY year
ORDER BY COUNT(name) desc
LIMIT    1



-- NOTE: very easy; should not even be in Medium section