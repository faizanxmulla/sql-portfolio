### Problem Statement

Given two tables `source` and `target`, identify the following:

- IDs present in the `source` table but not in the `target` table.

- IDs present in the `target` table but not in the `source` table.

- IDs present in both tables but with different names.

### Schema Setup

```sql
CREATE TABLE source (
    id INT, 
    name VARCHAR(5)
);

INSERT INTO source (id, name) VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D');


CREATE TABLE target (
    id INT, 
    name VARCHAR(5)
);

INSERT INTO target (id, name) VALUES 
(1, 'A'),
(2, 'B'),
(4, 'X'),
(5, 'F');
```

### Solution

```sql
-- Solution 1: using FULL OUTER JOIN

SELECT COALESCE(s.id, t.id) as id
       ,CASE WHEN t.name IS NULL THEN 'New in source'
             WHEN s.name IS NULL THEN 'New in target'
          ELSE 'Mismatch' 
         END as comment
FROM   source s FULL JOIN target t USING(id)
WHERE  s.name <> t.name OR s.name IS NULL OR t.name IS NULL


-- Solution 2: using UNION ALL and 

WITH CTE as (
    SELECT *, 'source' as table_name
    FROM   source
    UNION ALL
    SELECT *, 'target' as table_name
    FROM   target
)
SELECT   id
         ,CASE WHEN MIN(name) <> MAX(name) THEN 'Mismatch'
               WHEN MIN(table_name) = 'source' THEN 'New in source'
               WHEN MAX(table_name) = 'target' THEN 'New in target' 
         END as comment
FROM     CTE
GROUP BY 1
HAVING   COUNT(*)=1 or (COUNT(*)=2 and MIN(name) <> MAX(name))
ORDER BY 1
```

### Output

| id  | comment         |
|-----|-----------------|
| 3   | New in source   |
| 4   | Mismatch        |
| 5   | New in target   |

