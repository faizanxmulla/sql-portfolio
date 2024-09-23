### Problem Statement 

Write a query to obtain a list of departments with an average salary lower than the overall average salary of the company. 

However, when calculating the comapny's average salary, you must exclude the salaries of the department you are comparing it with. Essentially, the company's average salary will be dynamic for each department.


### Schema Setup

```sql
CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(20),
    department_id INT,
    salary INT,
    manager_id INT,
    emp_age INT
);

INSERT INTO employees VALUES
(1, 'Ankit', 100, 10000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 10000, 4, 37),
(4, 'Rohit', 100, 5000, 2, 16),
(5, 'Mudit', 200, 12000, 6, 55),
(6, 'Agam', 200, 12000, 2, 14),
(7, 'Sanjay', 200, 9000, 2, 13),
(8, 'Ashish', 200, 5000, 2, 12),
(9, 'Mukesh', 300, 6000, 6, 51),
(10, 'Rakesh', 300, 7000, 6, 50);
```

### Expected Output

department_id |	avg_salary |
--|--|
300 |	6500.00 |



### Solution Query

```sql
WITH dept_avg as (
	SELECT department_id, AVG(salary) OVER(PARTITION BY department_id) as dept_avg_salary
	FROM   employees
),
company_avg_excluding_dept as ( 
	SELECT e1.department_id, AVG(e2.salary) OVER(PARTITION BY e1.department_id) as company_avg_salary
	FROM   employees e1 JOIN employees e2 ON e1.department_id<>e2.department_id
)
SELECT distinct da.department_id, da.dept_avg_salary, ca.company_avg_salary
FROM   dept_avg da JOIN company_avg_excluding_dept ca USING(department_id)
WHERE  da.dept_avg_salary < ca.company_avg_salary



-- more easy and elegant solution: 

SELECT   department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM     employees e1
GROUP BY 1
HAVING   AVG(salary) < (
    SELECT AVG(salary)
    FROM   employees e2
    WHERE  e1.department_id != e2.department_id
)
```

