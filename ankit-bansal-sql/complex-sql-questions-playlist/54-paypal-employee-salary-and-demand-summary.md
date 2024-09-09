### Problem Statement 

Write SQL code to find the output table as below : 

`employeeid`, `employee_default_phone_number`, `total_entry`, `total_login`, `total_logout`, `latest_login` and `latest_logout`. 

### Schema Setup

```sql
CREATE TABLE employee_checkin_details (
  employeeid INT,
  entry_details VARCHAR(10),
  timestamp_details TIMESTAMP
);

INSERT INTO employee_checkin_details VALUES
(1000, 'login', '2023-06-16 01:00:15.34'),
(1000, 'login', '2023-06-16 02:00:15.34'),
(1000, 'login', '2023-06-16 03:00:15.34'),
(1000, 'logout', '2023-06-16 12:00:15.34'),
(1001, 'login', '2023-06-16 01:00:15.34'),
(1001, 'login', '2023-06-16 02:00:15.34'),
(1001, 'login', '2023-06-16 03:00:15.34'),
(1001, 'logout', '2023-06-16 12:00:15.34');

CREATE TABLE employee_details (
  employeeid INT,
  phone_number VARCHAR(15),
  isdefault BOOLEAN
);

INSERT INTO employee_details VALUES
(1001, '9999', FALSE),
(1001, '1111', FALSE),
(1001, '2222', TRUE),
(1003, '3333', FALSE);
```


### Solution Query

```sql
SELECT   ecd.employeeid, 
	     phone_number,
	     COUNT(*) as total_entry,
	     COUNT(*) FILTER(WHERE entry_details='login') as total_login,
	     COUNT(*) FILTER(WHERE entry_details='logout') as total_logout,
	     MAX(timestamp_details) FILTER(WHERE entry_details='login') as latest_login,
	     MAX(timestamp_details) FILTER(WHERE entry_details='logout') as latest_logout 
FROM     employee_checkin_details ecd RIGHT JOIN employee_details ed ON ecd.employeeid=ed.employeeid and ed.isdefault='True' 
GROUP BY 1, 2
```

