SELECT   college, COUNT(name) as player_count
FROM     nfl_combine
WHERE    college IS NOT NULL
GROUP BY college
ORDER BY player_count desc