WITH medals_tally AS (
    SELECT   event,
             team,
             COUNT(*) FILTER (WHERE medal = 'Gold') AS gold_medals,
             COUNT(*) FILTER (WHERE medal = 'Silver') AS silver_medals,
             COUNT(*) FILTER (WHERE medal = 'Bronze') AS bronze_medals,
             COUNT(*) FILTER (WHERE medal IS NOT NULL) AS total_medals
    FROM     olympics_athletes_events
    WHERE    games = '2016 Summer' AND city = 'Rio de Janeiro'
    GROUP BY 1, 2
),
ranked_teams AS (
    SELECT event,
           team,
           total_medals,
           RANK() OVER(PARTITION BY event ORDER BY total_medals DESC, team) AS rank
    FROM   medals_tally
),
top_teams AS (
    SELECT   event,
             COALESCE(MAX(CASE WHEN rank = 1 THEN team || ' with ' || total_medals || ' medals' END), 'No Team') AS gold_team,
             COALESCE(MAX(CASE WHEN rank = 2 THEN team || ' with ' || total_medals || ' medals' END), 'No Team') AS silver_team,
             COALESCE(MAX(CASE WHEN rank = 3 THEN team || ' with ' || total_medals || ' medals' END), 'No Team') AS bronze_team
    FROM     ranked_teams
    GROUP BY 1
)
SELECT   event, gold_team, silver_team, bronze_team
FROM     top_teams
ORDER BY 1



-- my initial approach: (getting empty result set)

WITH medals_tally AS (
    SELECT   team,
             event,
             COUNT(*) FILTER(WHERE medal='Gold') AS gold_medals,
             COUNT(*) FILTER(WHERE medal='Silver') AS silver_medals,
             COUNT(*) FILTER(WHERE medal='Bronze') AS bronze_medals
    FROM     olympics_athletes_events
    WHERE    games='2016 Summer' AND city='Rio de Janeiro'
    GROUP BY 1, 2
),
gold_team_cte AS (
    SELECT event, 
           team AS gold_team
    FROM   medals_tally
    WHERE  gold_medals > silver_medals AND gold_medals > bronze_medals
),
silver_team_cte AS (
    SELECT event, 
           team AS silver_team
    FROM   medals_tally
    WHERE  silver_medals > gold_medals AND silver_medals > bronze_medals
),
bronze_team_cte AS (
    SELECT event, 
           team AS bronze_team
    FROM   medals_tally
    WHERE  bronze_medals > silver_medals AND bronze_medals > gold_medals
)
SELECT event, 
       gold_team,
       silver_team, 
       bronze_team
FROM   gold_team_cte g JOIN silver_team_cte s USING(event)
                      JOIN bronze_team_cte b USING(event)