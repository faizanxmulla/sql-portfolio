### Problem Statement 

An organization is seeking to hire candidates for both junior and senior positions. They have a total budget of $50,000, with a priority on filling the senior positions first, followed by the junior positions.  

There are a total of 3 testcases. Write a SQL query to satisfy all the testcases. 

### Schema Setup

```sql
CREATE TABLE candidates (
  id INT PRIMARY KEY,
  positions VARCHAR(10) NOT NULL,
  salary INT NOT NULL
);

-- Test Case 1
INSERT INTO candidates VALUES 
(1, 'junior', 5000),
(2, 'junior', 7000),
(3, 'junior', 7000),
(4, 'senior', 10000),
(5, 'senior', 30000),
(6, 'senior', 20000);

-- Test Case 2
INSERT INTO candidates VALUES 
(20, 'junior', 10000),
(30, 'senior', 15000),
(40, 'senior', 30000);

-- Test Case 3
INSERT INTO candidates VALUES 
(1, 'junior', 15000),
(2, 'junior', 15000),
(3, 'junior', 20000),
(4, 'senior', 60000);

-- Test Case 4
INSERT INTO candidates VALUES 
(10, 'junior', 10000),
(40, 'junior', 10000),
(20, 'senior', 15000),
(30, 'senior', 30000),
(50, 'senior', 15000);
```

### Expected Output

- For testcase 1: 

    juniors | seniors | 
    --|--|
    3 | 2 | 

- For testcase 2: 

    juniors | seniors | 
    --|--|
    0 | 2 | 

- For testcase 3: 

    juniors | seniors | 
    --|--|
    3 | 0 | 

- For testcase 4: 

    juniors | seniors | 
    --|--|
    2 | 2 | 




### Solution Query

```sql
-- Solution 1: a bit long; but very clear and easy to understand.

WITH senior_positions as (
	SELECT *, SUM(salary) FILTER(WHERE positions='senior') OVER(ORDER BY salary) as seniors_cum_salary
	FROM   candidates
),
remaining_budget_cte as (
	SELECT 50000 - MAX(seniors_cum_salary) as remaining_budget_for_juniors
	FROM   senior_positions
	WHERE  seniors_cum_salary < 50000
),
junior_positions as (
	SELECT *, SUM(salary) OVER(ORDER BY salary) as juniors_cum_salary
	FROM   candidates, remaining_budget_cte
	WHERE  positions='junior' and salary <= remaining_budget_for_juniors
),
hired_individuals as (
	SELECT id, positions, salary
	FROM   senior_positions
	WHERE  seniors_cum_salary <= 50000
	UNION ALL
	SELECT id, positions, salary
	FROM   junior_positions
	WHERE  juniors_cum_salary <= (
		    SELECT remaining_budget_for_juniors
		    FROM   remaining_budget_cte
		)
)
SELECT COUNT(*) FILTER(WHERE positions='junior') as juniors,
       COUNT(*) FILTER(WHERE positions='senior') as seniors
FROM   hired_individuals
```

```sql
-- Solution 2: much shorter

WITH total_salary AS (
    SELECT *, SUM(salary) OVER(PARTITION BY positions ORDER BY salary) AS running_salary
    FROM   candidates
),
seniors AS (
    SELECT * 
    FROM   total_salary
    WHERE  positions= 'senior' AND running_salary <= 50000
),
hired_individuals as (
    SELECT * 
	FROM   seniors
	UNION ALL
	SELECT * 
	FROM   total_salary
	WHERE  positions = 'junior' AND running_salary <= 50000 - (SELECT SUM(salary) FROM seniors)
	
)
SELECT COUNT(*) FILTER(WHERE positions='junior') as juniors,
       COUNT(*) FILTER(WHERE positions='senior') as seniors
FROM   hired_individuals
```

