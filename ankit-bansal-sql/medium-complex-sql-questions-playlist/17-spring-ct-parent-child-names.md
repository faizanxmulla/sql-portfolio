### Problem Statement

Write a query that prints the names of a child and his parents in individual columns respectively in the order of the name of the child. 

### Schema Setup

```sql
CREATE TABLE people (
    id INT PRIMARY KEY NOT NULL,
    name VARCHAR(20),
    gender CHAR(2)
);

CREATE TABLE relations (
    c_id INT,
    p_id INT,
    FOREIGN KEY (c_id) REFERENCES people(id),
    FOREIGN KEY (p_id) REFERENCES people(id)
);


INSERT INTO people (id, name, gender) VALUES
(107, 'Days', 'F'),
(145, 'Hawbaker', 'M'),
(155, 'Hansel', 'F'),
(202, 'Blackston', 'M'),
(227, 'Criss', 'F'),
(278, 'Keffer', 'M'),
(305, 'Canty', 'M'),
(329, 'Mozingo', 'M'),
(425, 'Nolf', 'M'),
(534, 'Waugh', 'M'),
(586, 'Tong', 'M'),
(618, 'Dimartino', 'M'),
(747, 'Beane', 'M'),
(878, 'Chatmon', 'F'),
(904, 'Hansard', 'F');

INSERT INTO relations (c_id, p_id) VALUES
(145, 202),
(145, 107),
(278, 305),
(278, 155),
(329, 425),
(329, 227),
(534, 586),
(534, 878),
(618, 747),
(618, 904);
```


### Expected Output


| child      | father    | mother  |
|------------|-----------|---------|
| Dimartino  | Beane     | Hansard |
| Hawbaker   | Blackston | Days    |
| Keffer     | Canty     | Hansel  |
| Mozingo    | Nolf      | Criss   |
| Waugh      | Tong      | Chatmon |



### Solution Query

```sql
-- Solution 1: solved on own/first attempt w/o any hints

WITH parents_cte as (
	SELECT *
	FROM   people p JOIN relations r ON p.id=r.p_id
)
,children_cte as (
	SELECT *
	FROM   people p JOIN relations r ON p.id=r.c_id
)
SELECT   cc.name as child, 
	     MAX(pc.name) FILTER(WHERE pc.gender='M') as father,     
	     MAX(pc.name) FILTER(WHERE pc.gender='F') as mother  
FROM     parents_cte pc JOIN children_cte cc ON pc.id=cc.p_id 
GROUP BY 1
ORDER BY 1


-- Solution 2: similar approach; just different join conditions.

WITH father_cte as (
	SELECT r.c_id, p.name as father_name
	FROM   people p JOIN relations r ON p.id=r.p_id and gender='M'
)
, mother_cte as (
	SELECT r.c_id, p.name as mother_name
	FROM   people p JOIN relations r ON p.id=r.p_id and gender='F'
)
SELECT   f.c_id as child, 
	     f.father_name as father,
	     m.mother_name as mother  
FROM     father_cte f JOIN mother_cte m USING(c_id)
ORDER BY 1


-- Solution 3: using just LEFT joins

SELECT   r.c_id,
         MAX(f.name) AS father_name,
         MAX(m.name) AS mother_name
FROM     relations r LEFT JOIN people m ON r.p_id=m.id AND m.gender='F'
                     LEFT JOIN people f ON r.p_id=f.id AND f.gender='M'
GROUP BY 1


-- Solution 4: most easy

SELECT   r.c_id AS child_id,
         MAX(CASE WHEN p.gender = 'F' THEN name END) AS mother_name,
         MAX(CASE WHEN p.gender = 'M' THEN name END) AS father_name
FROM     relations r JOIN people p ON r.p_id = p.id
GROUP BY 1



-- NOTE: 

-- Solutions 2, 3, and 4 don't include the child's name in the output, which should be included since we're expected to order by it. 

-- It's acceptable for learning purposes, but my solution 1 provides the exact expected output.
```