-- home_team_goals is the number of goals scored by the home team.
-- away_team_goals is the number of goals scored by the away team.
-- The winner of the match is the team with the higher number of goals.


-- Write an SQL query to report the statistics of the league. 
-- The statistics should be built using the played matches where the winning team gets three points and the losing team gets no points. 

-- If a match ends with a draw, both teams get one point.

-- Each row of the result table should contain:

-- - team_name - The name of the team in the Teams table.
-- - matches_played - The number of matches played as either a home or away team.
-- - points - The total points the team has so far.
-- - goal_for - The total number of goals scored by the team across all matches.
-- - goal_against - The total number of goals scored by opponent teams against this team across all matches.
-- - goal_diff - The result of goal_for - goal_against.

-- Return the result table in descending order by points. If two or more teams have the same points, order them in descending order by goal_diff. 
-- If there is still a tie, order them by team_name in lexicographical order.




WITH cte AS (
 SELECT
   t.team_name,
   CASE
     WHEN home_team_id = t.team_id THEN
       CASE
         WHEN home_team_goals > away_team_goals THEN 3
         WHEN home_team_goals = away_team_goals THEN 1
         ELSE 0
       END
     WHEN away_team_id = t.team_id THEN
       CASE
         WHEN away_team_goals > home_team_goals THEN 3
         WHEN away_team_goals = home_team_goals THEN 1
         ELSE 0
       END
   END AS points,
   CASE
     WHEN home_team_id = t.team_id THEN home_team_goals
     ELSE away_team_goals
   END AS goal_for,
   CASE
     WHEN home_team_id = t.team_id THEN away_team_goals
     ELSE home_team_goals
   END AS goal_against
 FROM
   Teams t
   LEFT JOIN Matches m ON t.team_id IN (m.home_team_id, m.away_team_id)
)
SELECT   team_name, 
         COUNT(*) AS matches_played, 
         SUM(points) AS points, 
         SUM(goal_for) AS goal_for, 
         SUM(goal_against) AS goal_against, 
         SUM(goal_for) - SUM(goal_against) AS goal_diff
FROM     cte
GROUP BY 1
ORDER BY 3 DESC, 6 DESC, 1



-- remarks: couldn't solve on own. 