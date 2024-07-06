### Problem Statement

The job position table contains the available job vacancies & the employee table mentions the employees who already filled some of the vacancies. 

Write a SQL query using the 2 above mentioned tables to return the output as shown below.

### Expected Output

| Title            | Group | Level | Payscale | Employee_Name      |
|------------------|-------|-------|----------|--------------------|
| General manager  | A     | I-15  | 10000    | John Smith         |
| Manager          | B     | I-14  | 9000     | Jane Doe           |
| Manager          | B     | I-14  | 9000     | Michael Brown      |
| Manager          | B     | I-14  | 9000     | Emily Johnson      |
| Manager          | B     | I-14  | 9000     | Vacant             |
| Asst. Manager    | C     | I-13  | 8000     | William Lee        |
| Asst. Manager    | C     | I-13  | 8000     | Jessica Clark      |
| Asst. Manager    | C     | I-13  | 8000     | Christopher Harris |
| Asst. Manager    | C     | I-13  | 8000     | Olivia Wilson      |
| Asst. Manager    | C     | I-13  | 8000     | Daniel Martinez    |
| Asst. Manager    | C     | I-13  | 8000     | Sophia Miller      |
| Asst. Manager    | C     | I-13  | 8000     | Vacant             |
| Asst. Manager    | C     | I-13  | 8000     | Vacant             |
| Asst. Manager    | C     | I-13  | 8000     | Vacant             |
| Asst. Manager    | C     | I-13  | 8000     | Vacant             |


### Schema setup

```sql
DROP TABLE IF EXISTS job_positions;
CREATE TABLE job_positions (
    id INT,
    title VARCHAR(100),
    groups VARCHAR(10),
    levels VARCHAR(10),
    payscale INT,
    totalpost INT
);

INSERT INTO job_positions (id, title, groups, levels, payscale, totalpost) VALUES 
(1, 'General manager', 'A', 'l-15', 10000, 1),
(2, 'Manager', 'B', 'l-14', 9000, 5),
(3, 'Asst. Manager', 'C', 'l-13', 8000, 10);
```
```sql
DROP TABLE IF EXISTS job_employees;
CREATE TABLE job_employees (
    id INT,
    name VARCHAR(100),
    position_id INT
);

INSERT INTO job_employees (id, name, position_id) VALUES
(1, 'John Smith', 1),
(2, 'Jane Doe', 2),
(3, 'Michael Brown', 2),
(4, 'Emily Johnson', 2),
(5, 'William Lee', 3),
(6, 'Jessica Clark', 3),
(7, 'Christopher Harris', 3),
(8, 'Olivia Wilson', 3),
(9, 'Daniel Martinez', 3),
(10, 'Sophia Miller', 3);
```

### Solution Query

```sql
-- Solution 1: using GENERATE_SERIES() function.

WITH numbered_employees AS (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY position_id ORDER BY id) AS rn
	FROM   job_employees
),
positions AS (
	SELECT *, generate_series(1, totalpost) AS series
	FROM   job_positions
)
SELECT p.title, p.groups, p.levels, p.payscale, COALESCE(e.name, 'Vacant') AS employee_name
FROM   positions p LEFT JOIN numbered_employees e ON e.rn = p.series AND e.position_id = p.id;


-- Solution 2: using RECURSIVE CTE

WITH RECURSIVE cte AS (
    SELECT p.id, p.title, p.groups, p.levels, p.payscale, 
           '' AS employee_name, p.totalpost
    FROM   job_positions p 
    UNION ALL
    SELECT id, title, groups, levels, payscale, '' AS employee_name, 
           (totalpost - 1) AS totalpost
    FROM   cte 
    WHERE  totalpost > 1
)
SELECT  title, groups, levels, payscale, COALESCE(e.name, 'Vacant') AS employee_name
FROM    cte LEFT JOIN (
            SELECT *, 
                    ROW_NUMBER() OVER(PARTITION BY position_id ORDER BY id) AS rn 
            FROM   job_employees
		) e ON e.rn = cte.totalpost AND e.position_id = cte.id
ORDER BY 2, totalpost
```

