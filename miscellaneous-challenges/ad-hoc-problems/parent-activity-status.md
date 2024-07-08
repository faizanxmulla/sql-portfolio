### Problem Statement

The status column in the input table depicts the status of a child. 

- If the parent has at least one child in "Active" status, then we need to report the parent as "Active" (e.g., parent_id 1, 2, 4). 

- If none of the children are "Active" for a parent, then we need to report the parent as "Inactive" (e.g., parent_id 3, 5).

### Schema setup

```sql
CREATE TABLE parent_child_status (
    parent_id INT,
    child_id INT,
    status VARCHAR(10)
);

INSERT INTO parent_child_status (parent_id, child_id, status) VALUES
(1, 3, 'Active'),
(1, 4, 'Inactive'),
(1, 5, 'Active'),
(1, 6, 'Inactive'),
(2, 7, 'Active'),
(2, 8, 'Inactive'),
(3, 9, 'Inactive'),
(4, 10, 'Inactive'),
(4, 11, 'Active'),
(5, 12, 'Inactive'),
(5, 13, 'Inactive');
```

### Solution Queries

#### Solution 1:

```sql
WITH active_parents AS (
	SELECT   parent_id, status
	FROM     parent_child_status
	WHERE    status='Active'
	GROUP BY 1, 2
),
inactive_parents AS (
	SELECT parent_id, status
	FROM   parent_child_status
	WHERE  parent_id NOT IN (SELECT parent_id FROM active_parents)
)
SELECT * 
FROM   active_parents
UNION
SELECT * 
FROM   inactive_parents
ORDER BY 1
```


#### Solution 2:

```sql
-- Logic: same as solution 1, but using subquery.

SELECT parent_id, status
FROM   parent_child_status
WHERE  status = 'Active'
UNION
SELECT parent_id, status
FROM   parent_child_status a
WHERE  status = 'Inactive' AND NOT EXISTS (
    SELECT 1 
    FROM   parent_child_status b
    WHERE  b.status = 'Active' AND b.parent_id = a.parent_id
)
ORDER BY 1
```


#### Solution 3:

```sql
-- Logic: 

-- The `ORDER BY status` clause is significant because it ensures that the row with the status "Inactive" will have `rn` as 1 when there are no "Active" statuses present for a parent.

WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY parent_id ORDER BY status) AS rn  
    FROM   parent_child_status
)
SELECT parent_id, status 
FROM   cte
WHERE  rn = 1;
```


#### Solution 4:

```sql
-- Logic: same as solution 2, but using subquery.

SELECT parent_id, status
FROM (
	    SELECT *, ROW_NUMBER() OVER(PARTITION BY parent_id ORDER BY status) AS rn
	    FROM   parent_child_status
		) x
WHERE x.rn = 1;
```


#### Solution 5:

```sql
SELECT a.parent_id,
       CASE WHEN b.status IS NULL THEN 'Inactive' ELSE b.status END AS status
FROM (
    SELECT DISTINCT parent_id 
    FROM   parent_child_status
) AS a
LEFT JOIN (
    SELECT DISTINCT parent_id, status 
    FROM   parent_child_status
    WHERE  status = 'Active'
) AS b USING(parent_id)
ORDER BY 1
```


#### Solution 6:

```sql
-- Logic: most easy and simple solution of all alternatives

SELECT   parent_id, MIN(status) AS status
FROM     parent_child_status
GROUP BY 1
ORDER BY 1
```




