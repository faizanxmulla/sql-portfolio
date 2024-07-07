### Problem Statement

Find total runs in each over. 

*Assumption:* Each over has only 6 balls.

### Schema setup

```sql
DROP TABLE IF EXISTS match_score;
CREATE TABLE match_score (
	balls	int,
	runs	int
);

SELECT balls, ROUND(random() * 6) as runs
FROM   generate_series(1, 120) as balls


-- In cricket, it is generally not possible to score 5 runs off a single ball, excluding cases of extras or penalties.
-- so, removing entries with 5 runs and replacing them with 1 or 2 runs, which occur more frequently.

UPDATE match_score
SET runs = ROUND(random() * 2) 
WHERE runs = 5;
```

### Solution Query

```sql
-- Solution 1: using NTILE

WITH get_overs AS (
	SELECT *, NTILE(20) OVER(ORDER BY balls) as overs
	FROM   match_score
)
SELECT   overs, SUM(runs) as runs_per_over
FROM     get_overs
GROUP BY 1
ORDER BY 1


-- Solution 2: 

SELECT   CASE WHEN balls % 6 = 0 THEN balls/6 ELSE (balls / 6) +1 END AS overs,
         SUM(runs) as runs_per_over
FROM     match_score
GROUP BY 1
```

### Output

overs | runs_per_over |
--|--|
1 |	24 |
2 |	13 |
3 |	20 |
4 |	9 |
5 |	11 |
6 |	20 |
7 |	17 |
8 |	11 |
9 |	14 |
10 |	14 |
11 |	11 |
12 |	14 |
13 |	11 |
14 |	24 |
15 |	17 |
16 |	16 |
17 |	16 |
18 |	23 |
19 |	17 |
20 |	14 |
