### Problem Statement

Given a table with the results of matches between two teams, create a query to calculate the number of matches played, wins, and losses for each team.

### Schema setup

```sql
CREATE TABLE matches (
    team_1 VARCHAR(50),
    team_2 VARCHAR(50),
    winner VARCHAR(50)
);

INSERT INTO matches (team_1, team_2, winner) VALUES 
('India', 'SL', 'India'),
('SL', 'Aus', 'Aus'),
('SA', 'Eng', 'Eng'),
('Eng', 'NZ', 'NZ'),
('Aus', 'India', 'India');
```

### Expected output

| Team_Name | Matches_played | no_of_wins | no_of_losses |
|-----------|----------------|------------|--------------|
| India     | 2              | 2          | 0            |
| SL        | 2              | 0          | 2            |
| SA        | 1              | 0          | 1            |
| Eng       | 2              | 1          | 1            |
| Aus       | 2              | 1          | 1            |
| NZ        | 1              | 1          | 0            |

### Solution Query

```sql
WITH points_cte AS (
	SELECT team_1 AS team_name, CASE WHEN team_1 = winner THEN 1 ELSE 0 END as win_flag 
	FROM   matches
	UNION ALL	
	SELECT team_2 AS team_name, CASE WHEN team_2 = winner THEN 1 ELSE 0 END AS win_flag 
	FROM   matches
)
SELECT   team_name, 
         COUNT(*) AS no_of_matches_played, 
         SUM(win_flag) AS matches_won, 
	     COUNT(*) - SUM(win_flag) AS matches_lost 
FROM     points_cte 
GROUP BY 1 
ORDER BY 3 DESC
```

