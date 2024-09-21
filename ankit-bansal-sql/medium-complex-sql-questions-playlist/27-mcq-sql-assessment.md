### Problem Statement

Which SQL query lists every game with the goals scored by each team? 

The result set should show: `match_id`, `match_date`, `team1`, `score1`, `team2`, `score2`.

**NOTE**: `goal.teamid` is the team id of the player who scored a goal. 


### Schema Setup

```sql
CREATE TABLE game (
    match_id INT PRIMARY KEY,
    match_date DATE,
    stadium VARCHAR(50),
    team1 VARCHAR(50),
    team2 VARCHAR(50)
);

CREATE TABLE goal (
    match_id INT,
    team_id VARCHAR(50),
    player VARCHAR(50),
    goal_time TIMESTAMP,
    FOREIGN KEY (match_id) REFERENCES game(match_id)
);

INSERT INTO game (match_id, match_date, stadium, team1, team2) VALUES
(1, '2024-09-20', 'Wembley Stadium', 'Manchester United', 'Liverpool'),
(2, '2024-09-21', 'Camp Nou', 'Barcelona', 'Real Madrid'),
(3, '2024-09-22', 'Allianz Arena', 'Bayern Munich', 'Borussia Dortmund'),
(4, '2024-09-23', 'Santiago Bernabéu', 'Real Madrid', 'Atlético Madrid'),
(5, '2024-09-24', 'Old Trafford', 'Manchester United', 'Arsenal'),
(6, '2024-09-25', 'Etihad Stadium', 'Manchester City', 'Liverpool');

INSERT INTO goal (match_id, team_id, player, goal_time) VALUES
(1, 'Manchester United', 'Marcus Rashford', '15:30:00'),
(1, 'Liverpool', 'Mohamed Salah', '20:15:00'),
(2, 'Barcelona', 'Robert Lewandowski', '10:00:00'),
(2, 'Real Madrid', 'Karim Benzema', '23:00:00'),
(3, 'Bayern Munich', 'Thomas Muller', '12:00:00'),
(3, 'Bayern Munich', 'Joshua Kimmich', '18:30:00'),
(4, 'Real Madrid', 'Vinícius Júnior', '17:00:00'),
(4, 'Atlético Madrid', 'Antoine Griezmann', '22:30:00'),
(5, 'Manchester United', 'Bruno Fernandes', '12:15:00'),
(5, 'Manchester United', 'Marcus Rashford', '19:00:00'),
(6, 'Liverpool', 'Mohamed Salah', '10:30:00'),
(6, 'Liverpool', 'Trent Alexander-Arnold', '15:45:00'),
(6, 'Liverpool', 'Darwin Núñez', '23:00:00');
```


### Expected Output

| match_id | match_date | team1 | team_1_goal | team2 | team_2_goal |
|---|---|---|---|---|---|
| 1 | 2024-09-20 | Manchester United | 1 | Liverpool | 1 |
| 2 | 2024-09-21 | Barcelona | 1 | Real Madrid | 1 |
| 3 | 2024-09-22 | Bayern Munich | 2 | Borussia Dortmund | 0 |
| 4 | 2024-09-23 | Real Madrid | 1 | Atlético Madrid | 1 |
| 5 | 2024-09-24 | Manchester United | 2 | Arsenal | 0 |
| 6 | 2024-09-25 | Manchester City | 0 | Liverpool | 3 |


### Solution

```sql
SELECT   ga.match_id, 
         ga.match_date, 
         team1,
         SUM(CASE WHEN ga.team1 = go.team_id THEN 1 ELSE 0 END) AS team_1_goal,
         team2,
         SUM(CASE WHEN ga.team2 = go.team_id THEN 1 ELSE 0 END) AS team_2_goal
FROM     game ga LEFT JOIN goal go USING(match_id)
GROUP BY 1, 2, 3, 5
```