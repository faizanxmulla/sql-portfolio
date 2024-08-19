### Problem Statement

Find Sachin's Milestone Innnings / Matches.

### Dataset Link

[Dataset Google Sheets](https://docs.google.com/spreadsheets/d/1-utCWJ4PseJjLipW15Gm9lVG5J6FrmOR/edit?pli=1&gid=390450519#gid=390450519)


### Expected Output

| milestone_number | milestone_runs | milestone_innings | milestone_match_number |
|------------------|----------------|-------------------|------------------------|
| 1                | 1000           | 34                | 36                     |
| 2                | 5000           | 138               | 141                    |
| 3                | 10000          | 259               | 266                    |


### Solution Query

```sql
WITH CTE AS (
    SELECT Match,
           Innings,
           Runs,
           FLOOR(SUM(Runs) OVER (ORDER BY Match) / 1000.0) * 1000 AS milestone_runs
    FROM   sachin_career_stats
)
SELECT   ROW_NUMBER() OVER (ORDER BY milestone_runs) AS milestone_number,
         milestone_runs,
         MIN(Innings) AS milestone_innings,
         MIN(Match) AS milestone_match_number
FROM     CTE
WHERE    milestone_runs IN (1000, 5000, 10000)
GROUP BY 2
```