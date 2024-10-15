### Problem Statement

You are provided with a table named `numbers` containing a sequence of integers. Your objective is to obtain the expected output by figuring out the pattern used to generate it.

**Problem Credits:** [Analyst Adithya - YT](https://www.youtube.com/watch?v=I9Exs_4_VPw&list=PLRRWaBOk3DqeEUGvOEfYcHgxa1gS7KxPQ&index=2)

### Schema setup

```sql
CREATE TABLE numbers (
  number INT
);

INSERT INTO numbers (number) VALUES
(1), (2), (3), (6), (7), (9);
```

### Expected Output

id | id | 
--|--|
1 | 3 |
6 | 7 |
9 | 9 |

### Solution Query

```sql
WITH prev_missing as (
    SELECT id
    FROM   numbers 
    WHERE  id-1 NOT IN (SELECT DISTINCT id FROM numbers)
)
,next_missing as (
    SELECT id
    FROM   numbers 
    WHERE  id+1 NOT IN (SELECT DISTINCT id FROM numbers)
)
SELECT   p.id, n.id
FROM     prev_missing p, next_missing n 
WHERE    p.id <= n.id
GROUP BY 1, 2


-- note: we can also use ROW_NUMBER() window function instead.
```

