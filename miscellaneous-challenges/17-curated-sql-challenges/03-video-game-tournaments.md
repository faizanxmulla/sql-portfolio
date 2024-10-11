### Problem Statement

You have three tables: `tournaments`, `teams`, and `matches`.

* The `tournaments` table stores information about e-sports tournaments.

* The `teams` table contains details about esports teams.

* The `matches` table records individual matches within tournaments, including a unique match ID.


### Schema Setup

```sql
CREATE TABLE tournaments (
    tournament_id INT PRIMARY KEY,
    tournament_name VARCHAR(100),
    game_title VARCHAR(50),
    start_date DATE,
    end_date DATE,
    total_prize_pool DECIMAL(10,2),
    region VARCHAR(50)
);

INSERT INTO tournaments (tournament_id, tournament_name, game_title, start_date, end_date, total_prize_pool, region)
VALUES
    (1, 'The International 2023', 'Dota 2', '2023-10-12', '2023-10-29', 40298156, 'Southeast Asia'),
    (2, 'LoL Worlds 2023', 'League of Legends', '2023-10-15', '2023-11-19', 3229000, 'Korea'),
    (3, 'PGL CS:GO Major Copenhagen 2024', 'Counter-Strike: Global Offensive', '2024-02-17', '2024-03-01', 1250000, 'Denmark'),
    (4, 'Valorant Champions 2023', 'Valorant', '2023-09-10', '2023-09-20', 1000000, 'North America'),
    (5, 'Rainbow Six Invitational 2024', 'Rainbow Six Siege', '2024-01-12', '2024-01-26', 2000000, 'Europe'),
    (6, 'Overwatch World Cup 2023', 'Overwatch', '2023-12-01', '2023-12-15', 500000, 'North America');
```

```sql
CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50),
    country VARCHAR(50),
    foundation_year INT
);

INSERT INTO teams (team_id, team_name, country, foundation_year)
VALUES
    (1, 'Liquid', 'Netherlands', 2000),
    (2, 'G2 Esports', 'Germany', 2014),
    (3, 'FaZe Clan', 'United Kingdom', 2013),
    (4, 'Cloud9', 'United States', 2013),
    (5, 'Fnatic', 'United Kingdom', 2004),
    (6, 'Natus Vincere', 'Ukraine', 2009),
    (7, 'Astralis', 'Denmark', 2016),
    (8, 'Evil Geniuses', 'United States', 1999),
    (9, '100 Thieves', 'United States', 2017);
```

```sql
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    tournament_id INT,
    match_date DATE,
    winner_team_id INT,
    losing_team_id INT,
    match_duration_minutes INT,
    viewer_count INT,
    FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id),
    FOREIGN KEY (winner_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (losing_team_id) REFERENCES teams(team_id)
);

INSERT INTO matches (match_id, tournament_id, match_date, winner_team_id, losing_team_id, match_duration_minutes, viewer_count)
VALUES
    (1, 1, '2023-10-15', 1, 3, 48, 2750000),
    (2, 2, '2023-11-10', 2, 1, 35, 1920000),
    (3, 3, '2024-02-23', 3, 2, 52, 380000),
    (4, 1, '2023-10-16', 3, 2, 50, 2900000),
    (5, 1, '2023-10-18', 1, 2, 45, 2600000),
    (6, 2, '2023-11-12', 3, 1, 37, 1980000),
    (7, 2, '2023-11-15', 2, 3, 42, 2100000),
    (8, 3, '2024-02-25', 2, 1, 55, 390000),
    (9, 3, '2024-02-28', 3, 2, 49, 400000),
    (10, 4, '2023-09-12', 4, 5, 41, 1500000),
    (11, 4, '2023-09-14', 5, 4, 38, 1400000),
    (12, 5, '2024-01-13', 6, 7, 43, 500000),
    (13, 5, '2024-01-17', 7, 6, 39, 510000),
    (14, 6, '2023-12-03', 8, 9, 30, 200000),
    (15, 6, '2023-12-07', 9, 8, 29, 210000);
```


---

## Questions + Difficulty

### a. Easy

List the names of all tournaments for the game "League of Legends" along with their total prize pools.


#### Solution Query

```sql
SELECT tournament_name, total_prize_pool
FROM   tournaments
WHERE  game_title="League of Legends"
```

---


### b. Intermediate

Find the top 5 teams with the highest win rates in tournaments.

#### Solution Query

```sql
WITH all_teams as (
    SELECT winner_team_id as team_id 
    FROM   matches
    UNION ALL
    SELECT losing_team_id as team_id 
    FROM   matches
)
, matches_cte as (
    SELECT   team_id, COUNT(*) as total_matches_played
    FROM     all_teams
    GROUP BY 1
)
,wins_cte as (
    SELECT   winner_team_id as team_id, COUNT(*) as total_wins
    FROM     matches
    GROUP BY 1
)
SELECT   t.team_name, 
         (100.0 * w.total_wins / m.total_matches_played) as win_rate
FROM     teams t JOIN wins_cte w USING(team_id)
                 JOIN matches_cte m USING(team_id)
ORDER BY 2 DESC
LIMIT    5
```

---



### c. Advanced

For each tournament, calculate the average match duration and viewer count, along with the percentage difference from the overall averages across all tournaments.

#### Solution Query

```sql
WITH overall_stats as (
    SELECT AVG(match_duration_minutes) as overall_avg_duration,
           AVG(viewer_count) as overall_avg_viewership
    FROM   matches
)
SELECT   tournament_id,
         AVG(match_duration_minutes) - overall_avg_duration / overall_avg_duration * 100.0 as duration_percentage_diff,
         AVG(viewer_count) - overall_avg_viewership / overall_avg_viewership * 100.0 as viewers_percentage_diff
FROM     matches m CROSS JOIN overall_stats
GROUP BY 1, overall_avg_duration, overall_avg_viewership
ORDER BY 1
```


---

### d. Expert

Identify potential "rivalry" team pairs based on their frequency of matches against each other and closeness of their performance. Provide recommendations to leadership on how we might use “rivalry” to improve viewership.


#### Solution Query

```sql
WITH matchups AS (
    SELECT   LEAST(winner_team_id, losing_team_id) AS team1, 
             GREATEST(winner_team_id, losing_team_id) AS team2, 
             COUNT(*) AS match_count,
             SUM(CASE WHEN winner_team_id = LEAST(winner_team_id, losing_team_id) THEN 1 ELSE 0 END) AS team1_wins,
             SUM(CASE WHEN winner_team_id = GREATEST(winner_team_id, losing_team_id) THEN 1 ELSE 0 END) AS team2_wins
    FROM     matches
    GROUP BY 1, 2
)
SELECT   t1.team_name AS team1, 
         t2.team_name AS team2, 
         m.match_count, 
         m.team1_wins, 
         m.team2_wins, 
         ABS(m.team1_wins - m.team2_wins) AS win_difference
FROM     matchups m JOIN teams t1 ON m.team1 = t1.team_id
                    JOIN teams t2 ON m.team2 = t2.team_id
WHERE    m.match_count > 1 AND ABS(m.team1_wins - m.team2_wins) <= 1
ORDER BY 3 DESC, 6
```


**Recommendations for Improving Viewership:**


- *Highlight Rivalries*: Promote rivalry matchups during tournament advertisements and build storylines around their history.

- *Engage with Fans*: Use these rivalries to create social media campaigns, engage fans in voting for their favorite teams, and promote rematches.
---