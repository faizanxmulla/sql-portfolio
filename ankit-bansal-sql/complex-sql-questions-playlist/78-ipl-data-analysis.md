### Problem Statement

How many matches did each player play, and in how many of these did they bat and bowl?


### Schema Setup

refer videos description (too long to display here)



### Solution Query


```sql
-- Solution 1: my solution


WITH CTE as (
    SELECT   matchid, batter as player, 'batting' as play_type
    FROM     cricket_match
    GROUP BY matchid, batter
    UNION 
    SELECT   matchid, bowler as player, 'bowling' as play_type
    FROM     cricket_match
    GROUP BY matchid, bowler
)
SELECT   player, 
         COUNT(DISTINCT matchid) as total_matches,
         SUM(CASE WHEN play_type = 'batting' THEN 1 ELSE 0 END) as batting_matches,
         SUM(CASE WHEN play_type = 'bowling' THEN 1 ELSE 0 END) as bowling_matches
FROM     CTE
GROUP BY 1
ORDER BY 2 DESC
```

```sql  
-- Solution 2: mentos solution


WITH CTE as (
    SELECT batter as player, matchid as batting_matchid, NULL as bowling_matchid 
    FROM   cricket_match
    UNION
    SELECT bowler, NULL as batting_matchid, matchid as bowling_matchid 
    FROM   cricket_match
)
SELECT   player,
         COUNT(DISTINCT COALESCE(batting_matchid, bowling_matchid)) as total_matches_played,
         COUNT(batting_matchid) as batting_matches,
         COUNT(bowling_matchid) as bowler_matches
FROM     CTE
GROUP BY player
```