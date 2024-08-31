### Problem Statement
Write a query to find the number of gold medals per swimmer for swimmers who won only gold medals.

### Schema Setup

```sql
CREATE TABLE events (
    id INT,
    event VARCHAR(20),
    year int,
    gold VARCHAR(50),
    silver VARCHAR(50),
    bronze VARCHAR(50)
);

INSERT INTO events VALUES
(1, '100m', 2016, 'Amthhew Mcgraray', 'Donald', 'Barbara'),
(2, '200m', 2016, 'Nichole', 'Alvaro Eaton', 'Janet Smith'),
(3, '500m', 2016, 'Charles', 'Nichole', 'Susana'),
(4, '100m', 2016, 'Ronald', 'Maria', 'Paula'),
(5, '200m', 2016, 'Alfred', 'Carol', 'Steven'),
(6, '500m', 2016, 'Nichole', 'Alfred', 'Brandon'),
(7, '100m', 2016, 'Charles', 'Dennis', 'Susana'),
(8, '200m', 2016, 'Thomas', 'Dawn', 'Catherine'),
(9, '500m', 2016, 'Thomas', 'Dennis', 'Paula'),
(10, '100m', 2016, 'Charles', 'Dennis', 'Susana'),
(11, '200m', 2016, 'Jessica', 'Donald', 'Stefeney'),
(12, '500m', 2016, 'Thomas', 'Steven', 'Catherine');
```

### Expected Output

| player            | no_of_gold |
|-------------------|------------|
| Amthhew Mcgraray  | 1          |
| Charles           | 3          |
| Jessica           | 1          |
| Ronald            | 1          |
| Thomas            | 3          |

### Solution

```sql
-- Solution 1: using NOT IN and UNION ALL

SELECT   gold AS player, COUNT(*) AS no_of_gold
FROM     events
WHERE    gold NOT IN (SELECT silver FROM events UNION ALL SELECT bronze FROM events)
GROUP BY 1
ORDER BY 1


-- Solution 2: using UNION ALL and HAVING conditions.

WITH CTE as (
    SELECT gold as player_name, 'gold' as medal_type
    FROM   events
    UNION ALL
    SELECT silver as player_name, 'silver' as medal_type
    FROM   events
    UNION ALL
    SELECT bronze as player_name, 'bronze' as medal_type
    FROM   events
)
SELECT   player_name, COUNT(*) as no_of_gold
FROM     CTE
GROUP BY 1
HAVING   COUNT(distinct medal_type) = 1 and MAX(medal_type)='gold'
```

