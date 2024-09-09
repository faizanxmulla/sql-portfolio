### Problem Statement 

The `job_positions` table contains the available job vacancies, while the `job_employees` table indicates which of those vacancies have already been filled. 

Write a SQL query to generate the desired output as shown below.

### Schema Setup

```sql
CREATE TABLE job_positions (
  id INT,
  title VARCHAR(100),
  groups VARCHAR(10),
  levels VARCHAR(10),
  payscale INT,
  totalpost INT
);

CREATE TABLE job_employees (
  id INT,
  name VARCHAR(100),
  position_id INT
);


INSERT INTO job_positions VALUES 
(1, 'General manager', 'A', 'l-15', 10000, 1),
(2, 'Manager', 'B', 'l-14', 9000, 5),
(3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

INSERT INTO job_employees VALUES 
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

### Expected Output


| TITLE         | GROUP | LEVEL | PAYSCALE | EMPLOYEE_NAME    |
|---------------|-------|-------|----------|------------------|
| General manager | A   | I-15  | 10000    | John Smith       |
| Manager       | B     | I-14  | 9000     | Jane Doe         |
| Manager       | B     | I-14  | 9000     | Michael Brown    |
| Manager       | B     | I-14  | 9000     | Emily Johnson    |
| Manager       | B     | I-14  | 9000     | Vacant           |
| Manager       | B     | I-14  | 9000     | Vacant           |
| Asst. Manager | C     | I-13  | 8000     | William Lee      |
| Asst. Manager | C     | I-13  | 8000     | Jessica Clark    |
| Asst. Manager | C     | I-13  | 8000     | Christopher Harris |
| Asst. Manager | C     | I-13  | 8000     | Olivia Wilson    |
| Asst. Manager | C     | I-13  | 8000     | Daniel Martinez  |
| Asst. Manager | C     | I-13  | 8000     | Sophia Miller    |
| Asst. Manager | C     | I-13  | 8000     | Vacant           |
| Asst. Manager | C     | I-13  | 8000     | Vacant           |
| Asst. Manager | C     | I-13  | 8000     | Vacant           |
| Asst. Manager | C     | I-13  | 8000     | Vacant           |



### Solution Query

```sql
-- Solution: using Recursive CTE

WITH RECURSIVE CTE as (
	SELECT id, title, groups, levels, payscale, totalpost, 1 as rn
	FROM   job_positions
	UNION ALL
	SELECT id, title, groups, levels, payscale, totalpost, rn+1
	FROM   CTE 
	WHERE  rn+1 <= totalpost
),
employee_data as (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY position_id ORDER BY id) as rn
	FROM   job_employees
)
SELECT title, groups, levels, payscale, COALESCE(name, 'Vacant') as name
FROM   CTE c LEFT JOIN employee_data ed ON c.id=ed.position_id and c.rn=ed.rn
```

