SELECT   games, COUNT(distinct id) as athletes_count
FROM     olympics_athletes_events
GROUP BY games
ORDER BY athletes_count desc
LIMIT    1