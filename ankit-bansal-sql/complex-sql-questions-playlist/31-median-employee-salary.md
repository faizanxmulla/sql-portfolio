### Problem Statement | [Leetcode Link](https://leetcode.com/problems/median-employee-salary/description/)

Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.


### Schema Setup

```sql
CREATE TABLE employee (
    emp_id INT,
    company VARCHAR(10),
    salary INT
);

INSERT INTO employee (emp_id, company, salary) VALUES
(1, 'A', 2341),
(2, 'A', 341),
(3, 'A', 15),
(4, 'A', 15314),
(5, 'A', 451),
(6, 'A', 513),
(7, 'B', 15),
(8, 'B', 13),
(9, 'B', 1154),
(10, 'B', 1345),
(11, 'B', 1221),
(12, 'B', 234),
(13, 'C', 2345),
(14, 'C', 2645),
(15, 'C', 2645),
(16, 'C', 2652),
(17, 'C', 65);
```


### Expected Output

+-----+------------+--------+
| id  | company    | salary |
+-----+------------+--------+
| 5   | A          | 451    |
| 6   | A          | 513    |
| 12  | B          | 234    |
| 9   | B          | 1154   |
| 14  | C          | 2645   |
+-----+------------+--------+

### Solution Query

```sql
-- Solution 1: 
-- more instinctive solution.

SELECT   company, PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY Salary) AS median
FROM     employee_salaries
GROUP BY 1


-- Solution 2 : 
-- more correct solution according to the question asked, also get the bonus marks for not using built in SQL function. 

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS rn,
           COUNT(*) OVER(PARTITION BY company) AS cnt
    FROM   employee
)
SELECT id, company, salary
FROM   CTE
WHERE  rn BETWEEN cnt/2 AND cnt/2 + 1
```
