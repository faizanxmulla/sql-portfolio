### Problem Statement

Write a SQL query to find the details of employees with the 3rd highest salary in each department. In case there are less than 3 employees in a department, then return the employee details with the lowest salary in that department.

### Schema Setup

```sql
CREATE TABLE emp (
    emp_id INT,
    emp_name VARCHAR(50),
    salary INT,
    dep_id INT,
    dep_name VARCHAR(50)
);

INSERT INTO emp VALUES 
(1, 'Ankit', 14300, 100, 'Analytics'),
(2, 'Vikas', 12100, 100, 'Analytics'),
(3, 'Rohit', 7260, 100, 'Analytics'),
(4, 'Agam', 15600, 200, 'IT'),
(5, 'Mudit', 15000, 200, 'IT'),
(6, 'Mohit', 14000, 200, 'IT'),
(7, 'Sanjay', 12000, 200, 'IT'),
(8, 'Ashish', 7000, 200, 'IT'),
(9, 'Rakesh', 8000, 300, 'HR'),
(10, 'Mukesh', 7000, 300, 'HR'),
(11, 'Akhil', 4000, 500, 'Ops');
```

### Expected Output

| emp_id | emp_name | salary | dep_id | dep_name |
|--------|----------|--------|--------|----------|
| 3      | Rohit    | 7260   | 100    | Analytics|
| 6      | Mohit    | 14000  | 200    | IT       |
| 10     | Mukesh   | 7000   | 300    | HR       |
| 11     | Akhil    | 4000   | 500    | Ops      |

### Solution Query

```sql
WITH ranked_employees AS (
    SELECT emp_id, emp_name, salary, dep_id, dep_name,
           DENSE_RANK() OVER(PARTITION BY dep_id ORDER BY salary DESC) AS rn,
           COUNT(*) OVER(PARTITION BY dep_id) AS cnt
    FROM   emp
) 
SELECT   emp_id, emp_name, salary, dep_id, dep_name
FROM     ranked_employees
WHERE    (rn = 3 OR cnt < 3 AND rn = cnt)
ORDER BY 4, 3 DESC
```
