### Problem Statement

Given a table named users with a column email, which may contain duplicate email addresses in varying cases (e.g., "Example@Domain.com" and "example@domain.com").

Write a SQL query to retrieve a list of email addresses in lowercase format. 

The result should only include email addresses that are completely in lowercase.


### Schema Setup

```sql
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(15), 
    email_id VARCHAR(15)
);

DELETE FROM employees;

INSERT INTO employees (employee_id,employee_name, email_id) VALUES 
('101','Liam Alton', 'li.al@abc.com'),
('102','Josh Day', 'jo.da@abc.com'),
('103','Sean Mann', 'se.ma@abc.com'), 
('104','Evan Blake', 'ev.bl@abc.com'),
('105','Toby Scott', 'jo.da@abc.com'),
('106','Anjali Chouhan', 'JO.DA@ABC.COM'),
('107','Ankit Bansal', 'AN.BA@ABC.COM');

ALTER TABLE employees
ALTER COLUMN email_id VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS;
```


### Expected Output

| employee_id | employee_name| email           |
|-------------|--------------|-----------------|
| 107         | Ankit Bansal | AN.BA@ABC.COM   |
| 104         | Evan Blake   | ev.bl@abc.com   |
| 105         | Toby Scott   | jo.da@abc.com   |
| 102         | Josh Day     | jo.da@abc.com   |
| 101         | Liam Alton   | li.al@abc.com   |
| 103         | Sean Mann    | se.ma@abc.com   |



### Solution

```sql
WITH CTE as (
	SELECT *, 
		   ASCII(email_id) as email_ascii, 
	       RANK() OVER(PARTITION BY LOWER(email_id) ORDER BY ASCII(email_id) desc) as rank  
	FROM   employees
)
SELECT *
FROM   CTE
WHERE  rank=1
```