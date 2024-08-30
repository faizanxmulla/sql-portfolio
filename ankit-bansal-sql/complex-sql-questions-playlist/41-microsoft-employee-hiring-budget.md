### Problem Statement

A company wants to hire new employees. The budget of the company for salaries is $70,000. The company's criteria for hiring are:

1. Keep hiring the senior with the smallest salary until you cannot hire any more seniors.

2. Use the remaining budget to hire the junior with the smallest salary.

3. Keep hiring the junior with the smallest salary until you cannot hire any more juniors.

Write an SQL query to find the seniors and juniors hired under the mentioned criteria.

### Schema Setup

```sql
CREATE TABLE candidates (
    emp_id INT,
    experience VARCHAR(10),
    salary INT
);

INSERT INTO candidates VALUES
(1, 'Junior', 10000),
(2, 'Junior', 15000),
(3, 'Senior', 40000),
(4, 'Senior', 16000),
(5, 'Senior', 20000);
```

### Expected Output

| emp_id | experience | salary |
|--------|------------|--------|
| 4      | Senior     | 16000  |
| 5      | Senior     | 20000  |
| 1      | Junior     | 10000  |
| 2      | Junior     | 15000  |


### Solution Query

```sql
-- Solution 1: my attempt; much longer but also much easier to understand.

WITH seniors_cte AS (
    SELECT *,
           SUM(salary) FILTER(WHERE experience = 'Senior') OVER(ORDER BY salary) AS seniors_cumulative_salary
    FROM   candidates
),
remaining_budget_cte AS (
    SELECT 70000 - MAX(seniors_cumulative_salary) AS remaining_salary_for_juniors
    FROM   seniors_cte
    WHERE  seniors_cumulative_salary <= 70000
),
juniors_cte AS (
    SELECT *, 
           SUM(salary) OVER(ORDER BY salary) AS juniors_cumulative_salary
    FROM   candidates, remaining_budget_cte
    WHERE  experience = 'Junior' AND salary <= remaining_salary_for_juniors
)
SELECT emp_id, experience, salary
FROM   seniors_cte
WHERE  seniors_cumulative_salary <= 70000

UNION ALL

SELECT emp_id, experience, salary
FROM   juniors_cte
WHERE  juniors_cumulative_salary <= (
    SELECT remaining_salary_for_juniors
    FROM   remaining_budget_cte
);



-- Solution 2: video solution; much shorter

WITH total_sal AS (
    SELECT *, SUM(salary) OVER(PARTITION BY experience ORDER BY salary) AS running_sal
    FROM   candidates
),
seniors AS (
    SELECT * 
    FROM   total_sal
    WHERE  experience = 'Senior' AND running_sal <= 70000
)
SELECT * 
FROM   total_sal
WHERE  experience = 'Junior' AND running_sal <= 70000 - (SELECT SUM(salary) FROM seniors)

UNION ALL

SELECT * 
FROM   seniors
```
