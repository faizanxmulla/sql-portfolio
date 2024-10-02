SELECT   medal,
         SUM(CASE WHEN year=2000 THEN 1 ELSE 0 END) as medals_2000,
         SUM(CASE WHEN year=2004 THEN 1 ELSE 0 END) as medals_2004,
         SUM(CASE WHEN year=2008 THEN 1 ELSE 0 END) as medals_2008,
         SUM(CASE WHEN year=2012 THEN 1 ELSE 0 END) as medals_2012,
         SUM(CASE WHEN year=2016 THEN 1 ELSE 0 END) as medals_2016,
         COUNT(medal) as total_medals
FROM     olympics_athletes_events
WHERE    team='China' 
         and season = 'Summer'
         and year between 2000 and 2016
         and medal IS NOT NULL
GROUP BY 1
ORDER BY 7 DESC