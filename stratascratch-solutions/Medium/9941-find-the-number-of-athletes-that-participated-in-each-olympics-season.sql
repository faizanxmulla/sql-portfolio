SELECT   season, COUNT(distinct id) as athletes_count
FROM     olympics_athletes_events
GROUP BY season