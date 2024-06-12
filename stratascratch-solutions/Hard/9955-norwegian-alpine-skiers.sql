SELECT DISTINCT name
FROM   olympics_athletes_events
WHERE  sport = 'Alpine Skiing' and 
       noc = 'NOR' and 
       year = 1992 and 
       name NOT IN (
                    SELECT DISTINCT name
                    FROM   olympics_athletes_events
                    WHERE  sport = 'Alpine Skiing' and 
                           noc = 'NOR' and 
                           year = 1994
                )