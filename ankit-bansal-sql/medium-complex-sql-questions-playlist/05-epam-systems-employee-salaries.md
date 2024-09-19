### Problem Statement

Write a SQL query to return all employees whose salary is the same within the same department.


### Schema Setup

```sql
CREATE TABLE emp_salary (
    emp_id INT,
    name VARCHAR(50),
    salary INT,
    dept_id INT
);

INSERT INTO emp_salary VALUES
(101, 'sohan', 3000, 11),
(104, 'cat', 3000, 11),
(108, 'kamal', 8000, 11),
(105, 'suresh', 4000, 12),
(109, 'mahesh', 7000, 12),
(102, 'rohan', 4000, 12),
(103, 'mohan', 5000, 13);
```


### Expected Output

| emp_id | name   | salary | dept_id |
|--------|--------|--------|---------|
| 101    | sohan  | 3000   | 11      |
| 104    | cat    | 3000   | 11      |
| 105    | suresh | 4000   | 12      |
| 102    | rohan  | 4000   | 12      |


### Solution

```sql
-- Solution 1: using INNER JOIN

WITH CTE AS (
	SELECT   dept_id, salary
	FROM     emp_salary
	GROUP BY 1, 2
	HAVING   COUNT(*) > 1
)
SELECT emp_id, name, salary, dept_id
FROM   CTE c JOIN emp_salary es USING(dept_id, salary)



-- Solution 2: using RIGHT JOIN

WITH CTE AS (
	SELECT   dept_id, salary
	FROM     emp_salary
	GROUP BY 1, 2
	HAVING   COUNT(*) = 1
)
SELECT emp_id, name, salary, dept_id
FROM   CTE c RIGHT JOIN emp_salary es USING(dept_id, salary)
WHERE  c.dept_id IS NULL



-- my approach: 

SELECT *
FROM   emp_salary a JOIN emp_salary b ON a.dept_id=b.dept_id AND a.salary=b.salary 
WHERE  a.emp_id < b.emp_id


-- NOTE: using my approach getting same output but not in the same format (amount of columns)
```

