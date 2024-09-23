### Problem Statement

The input table has columns for `person` and `type`. 

The goal is to generate an output where adults and children are paired together. 

`For example:` If adults and children are attending a fair and riding on a ride, one adult can accompany one child. If there is an odd number of adults, one adult will be left alone.


### Schema Setup

```sql
CREATE TABLE family (
    person VARCHAR(5),
    type VARCHAR(10),
    age INT
);

DELETE FROM family;

INSERT INTO family VALUES 
('A1', 'Adult', 54),
('A2', 'Adult', 53),
('A3', 'Adult', 52),
('A4', 'Adult', 58),
('A5', 'Adult', 54),
('C1', 'Child', 20),
('C2', 'Child', 19),
('C3', 'Child', 22),
('C4', 'Child', 15);
```


### Expected Output

adult | child |
--|--|
A1 | C1 |
A2 | C2 |
A3 | C3 |
A4 | C4 |
A5 | NULL | 


### Solution Query

```sql
WITH adults_cte as (
    SELECT person as adult, ROW_NUMBER() OVER(ORDER BY person) as rn
    FROM   family
    WHERE  type = 'Adult'
),
children_cte as (
    SELECT person as child, ROW_NUMBER() OVER(ORDER BY person) as rn
    FROM   family
    WHERE  type = 'Child'
)
SELECT a.adult, c.child
FROM   adults_cte as a LEFT JOIN children_cte as c USING(rn)



-- NOTE: i tried initially using CROSS JOIN, and then proceeded to continue with Recursive CTE.
```