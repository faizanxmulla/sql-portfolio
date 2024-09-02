### Problem Statement

Write a SQL query to list employee names along with their manager's and senior manager's names.
The senior manager is the manager's manager.

### Schema Setup

```sql
CREATE TABLE employees (
    emp_id INT,
    emp_name varchar(50),
    manager_id INT
);

INSERT INTO employees VALUES 
(1, 'Ankit', 4),
(2, 'Mohit', 5),
(3, 'Vikas', 4),
(4, 'Rohit', 2),
(5, 'Mudit', 6),
(6, 'Agam', 2),
(7, 'Sanjay', 2),
(8, 'Ashish', 2),
(9, 'Mukesh', 6),
(10, 'Rakesh', 6);
```


### Expected Output

employee |	manager |	senior_manager |
--|--|--|
Rakesh |	Agam |	Mohit |
Ankit |	Rohit |	Mohit |
Vikas |	Rohit |	Mohit |
Mudit |	Agam |	Mohit |
Mukesh |	Agam |	Mohit |
Sanjay |	Mohit |	Mudit |
Agam |	Mohit |	Mudit |
Ashish |	Mohit |	Mudit |
Rohit |	Mohit |	Mudit |
Mohit |	Mudit |	Agam |


### Solution

```sql
SELECT e1.emp_name as Employee, 
       e2.emp_name as Manager, 
       e3.emp_name as Senior_Manager
FROM   employees e1 LEFT JOIN employees e2 on e1.manager_id = e2.emp_id
                    LEFT JOIN employees e3 on e2.manager_id = e3.emp_id
```

