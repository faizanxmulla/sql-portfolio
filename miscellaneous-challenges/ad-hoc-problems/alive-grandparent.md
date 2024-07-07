### Problem Statement 

Write a SQL query to return count of people whose grandparent is alive.


### Schema setup

```sql
CREATE TABLE family_tree (
    person_name VARCHAR(2),
    parent_name VARCHAR(2),
    status VARCHAR(5)
);

INSERT INTO family_tree (person_name, parent_name, status) VALUES
('A', 'X', 'Alive'),
('B', 'Y', 'Dead'),
('X', 'X1', 'Alive'),
('Y', 'Y1', 'Alive'),
('X1', 'X2', 'Alive'),
('Y1', 'Y2', 'Dead');
```

### Solution Query

```sql
WITH grandparent_cte AS (
	SELECT a.person_name as child, a.parent_name as parent, b.parent_name as grandparent, c.status 
	FROM   family_tree a LEFT JOIN family_tree b ON b.person_name=a.parent_name
						 LEFT JOIN family_tree c ON c.person_name=b.parent_name
)
SELECT child, grandparent
FROM   grandparent_cte
WHERE  status='Alive'
```


### Output

child | grandparent | 
--|--|
A | X1 |
