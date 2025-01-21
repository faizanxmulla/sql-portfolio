SELECT   noc, sex, COUNT(*) as n_athletes
FROM     olympics_athletes_events
WHERE    sport='Football'
         and medal='Gold'
GROUP BY noc, sex