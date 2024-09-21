### Problem Statement

Write a query to print the highest and lowest salary of each employee in each department.


### Schema Setup

```sql
CREATE TABLE employee (
    emp_name VARCHAR(10),
    dep_id INT,
    salary INT
);

DELETE FROM employee;

INSERT INTO employee VALUES 
('Siva', 1, 30000),
('Ravi', 2, 40000),
('Prasad', 1, 50000),
('Sai', 2, 20000);
```


### Expected Output

dep_id | emp_name_max_salary | emp_name_min_salary |
--|--|--|
1 | Prasad |  Siva |
2 | Ravi | Sai |


### Solution Query

```sql
-- Solution 1: using two RANK() functions; and aggregation function w/ CASE WHEN // aslo my approach

WITH CTE as (
    SELECT *, 
           RANK() OVER(PARTITION BY dep_id ORDER BY salary desc) as highest_rn, 
           RANK() OVER(PARTITION BY dep_id ORDER BY salary) as lowest_rn
    FROM   employee
)
SELECT   dep_id,
         MAX(CASE WHEN highest_rn=1 THEN emp_name END) AS emp_name_max_salary,
         MAX(CASE WHEN lowest_rn=1 THEN emp_name END) AS emp_name_min_salary
FROM     CTE
GROUP BY 1


-- Solution 2: almost the same approach

WITH CTE as (
    SELECT   dep_id, MAX(salary) as max_salary, MIN(salary) as min_salary
    FROM     employee
    GROUP BY 1
)
SELECT   dep_id,
         MAX(CASE WHEN salary=max_salary THEN emp_name ELSE NULL END) AS emp_name_max_salary,
         MAX(CASE WHEN salary=min_salary THEN emp_name ELSE NULL END) AS emp_name_min_salary
FROM     employee e JOIN CTE c USING(dep_id)
GROUP BY 1
ORDER BY 1
```