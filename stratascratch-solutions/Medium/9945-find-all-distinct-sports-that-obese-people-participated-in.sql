SELECT   sport
FROM     olympics_athletes_events
WHERE    weight IS NOT NULL
         and height IS NOT NULL
         and (weight * 100 * 100) / (height*height) > 30
GROUP BY sport