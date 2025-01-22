SELECT distinct name, 
       CASE 
            WHEN team ILIKE '%/%' THEN 'Multiple Teams'
            ELSE 'One Team'
       END as number_of_teams
FROM   olympics_athletes_events



-- NOTE: initially didnt know that '/' already exists in some of the team entries.