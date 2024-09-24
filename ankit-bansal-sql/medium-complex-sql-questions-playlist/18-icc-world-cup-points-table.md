### Problem Statement

Based on the `icc_world_cup` table, generate a points table for the teams. Assign points as follows:

- 2 points for a win

- 1 point for a draw

- 0 points for a loss

The resulting table should include the `team names`, `total matches played`, `wins`, `draws`, `losses`, and `total points`. The output should be sorted by `total points` in descending order.


### Schema Setup

```sql
CREATE TABLE icc_world_cup (
    match_no INT,
    team_1 VARCHAR(20),
    team_2 VARCHAR(20),
    winner VARCHAR(20)
);

INSERT INTO icc_world_cup VALUES 
(1, 'ENG', 'NZ', 'NZ'),
(2, 'PAK', 'NED', 'PAK'),
(3, 'AFG', 'BAN', 'BAN'),
(4, 'SA', 'SL', 'SA'),
(5, 'AUS', 'IND', 'IND'),
(6, 'NZ', 'NED', 'NZ'),
(7, 'ENG', 'BAN', 'ENG'),
(8, 'SL', 'PAK', 'PAK'),
(9, 'AFG', 'IND', 'IND'),
(10, 'SA', 'AUS', 'SA'),
(11, 'BAN', 'NZ', 'NZ'),
(12, 'PAK', 'IND', 'IND');
```


### Expected Output

| team | matches_played | wins | losses | points |
|------|----------------|------|--------|--------|
| IND  | 3              | 3    | 0      | 6      |
| NZ   | 3              | 3    | 0      | 6      |
| SA   | 2              | 2    | 0      | 4      |
| PAK  | 3              | 2    | 1      | 4      |
| ENG  | 2              | 1    | 1      | 2      |
| BAN  | 3              | 1    | 2      | 2      |
| AFG  | 2              | 0    | 2      | 0      |
| SL   | 2              | 0    | 2      | 0      |
| AUS  | 2              | 0    | 2      | 0      |
| NED  | 2              | 0    | 2      | 0      |



### Solution Query

```sql
WITH all_matches AS (
        SELECT   team_1 AS team,
                 COUNT(*) AS matches_played,
                 SUM(CASE WHEN team_1=winner THEN 1 ELSE 0 END) AS win_flag
        FROM     icc_world_cup
        GROUP BY 1
        UNION ALL
        SELECT   team_2 AS team,
                 COUNT(*) AS matches_played,
                 SUM(CASE WHEN team_2=winner THEN 1 ELSE 0 END) AS win_flag
        FROM     icc_world_cup
        GROUP BY 1
)	
SELECT   team,
	     SUM(matches_played) AS matches_played,  
	     SUM(win_flag) AS wins,
	     SUM(matches_played) - SUM(win_flag) AS losses,
	     SUM(win_flag)*2 as points
FROM     all_matches
GROUP BY 1
ORDER BY 5 DESC, 2
```