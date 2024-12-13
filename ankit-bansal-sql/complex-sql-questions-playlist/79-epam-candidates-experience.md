### Problem Statement

Write an SQL query that, for each experience level:

- Counts the total number of candidates.

- Calculates how many of them got a perfect score in each category they were requested to solve tasks for.

- **Note:** A `NULL` means the candidate was not requested to solve tasks in that category.


### Schema Setup

```sql
CREATE TABLE assessments (
    id INT,
    experience INT,
    sql INT,
    algo INT,
    bug_fixing INT
);

DELETE FROM assessments;
INSERT INTO assessments VALUES 
(1, 3, 100, NULL, 50),
(2, 5, NULL, 100, 100),
(3, 1, 100, 100, 100),
(4, 5, 100, 50, NULL),
(5, 5, 100, 100, 100);
```


### Expected Output

experience | max_score_students | total_students |
--|--|--|
1 | 1 | 1 |
3 | 0 | 1 |
5 | 2 | 3 |



### Solution Query


```sql
-- Solution 1: aam solution

SELECT   experience,
         SUM(
            CASE WHEN (
                CASE WHEN sql=100 or sql IS NULL THEN 1 ELSE 0 END 
                + CASE WHEN algo=100 or algo IS NULL THEN 1 ELSE 0 END 
                + CASE WHEN bug_fixing=100 or bug_fixing IS NULL THEN 1 ELSE 0 END
            ) = 3 THEN 1 ELSE 0 END) as max_score_students,
         COUNT(*) as total_students
FROM     assessments
GROUP BY experience
```

```sql  
-- Solution 2: mentos solution

WITH all_subjects_cte as (
    SELECT id, experience, sql AS score, 'sql' AS subject
    FROM   assessments
    UNION ALL
    SELECT id, experience, algo AS score, 'algo' AS subject
    FROM   assessments
    UNION ALL
    SELECT id, experience, bug_fixing AS score, 'bug_fixing' AS subject
    FROM   assessments
)
,perfect_score_cte as (
    SELECT    id, 
              experience,
              CASE 
                  WHEN SUM(CASE WHEN score IS NULL OR score = 100 THEN 1 ELSE 0 END) = (SELECT COUNT(DISTINCT subject) FROM all_subjects_cte) 
                  THEN 1 ELSE 0 
              END AS perfect_score_flag
    FROM      all_subjects_cte
    GROUP BY  id, experience
)
SELECT   experience, 
         SUM(perfect_score_flag) as max_score_students,
         COUNT(*) astotal_students
FROM     perfect_score_cte
GROUP BY experience
```

---

my initial attempt:

```sql
SELECT   experience,
         COUNT(*) FILTER(WHERE sql=100 or algo=100 or bug_fixing=100) as max_score_students,
         COUNT(*) as total_students
FROM     assessments
GROUP BY experience
```