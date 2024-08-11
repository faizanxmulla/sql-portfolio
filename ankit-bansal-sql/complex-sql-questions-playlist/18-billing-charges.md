### Problem Statement

Write an SQL query to calculate the `total charges` (totalcharges) for each employee by multiplying the `hours` worked (bill_hrs) with the corresponding `billing rate` (bill_rate) from the `Billings` table. 

The `bill_rate` should be the one that is valid as of the work_date for each entry in the `HoursWorked` table.


### Schema Setup

```sql
CREATE TABLE Billings (
    emp_name VARCHAR(10),
    bill_date DATE,
    bill_rate INT
);

INSERT INTO Billings VALUES
('Sachin', '01-JAN-1990', 25),
('Sehwag', '01-JAN-1989', 15),
('Dhoni', '01-JAN-1989', 20),
('Sachin', '05-FEB-1991', 30);


CREATE TABLE HoursWorked (
    emp_name VARCHAR(20),
    work_date DATE,
    bill_hrs INT
);

INSERT INTO HoursWorked VALUES
('Sachin', '01-JUL-1990', 3),
('Sachin', '01-AUG-1990', 5),
('Sehwag', '01-JUL-1990', 2),
('Sachin', '01-JUL-1991', 4);
```

### Expected Output

emp_name |	totalcharges |
--|--|
Sachin |	320 |
Sehwag |	30 |


### Solution Query

```sql
-- Solution 1: without using window function

SELECT h.emp_name, SUM(h.bill_hrs * b.bill_rate) AS totalcharges
FROM   HoursWorked h JOIN Billings b ON h.emp_name = b.emp_name 
       AND b.bill_date = (
            SELECT MAX(bill_date)
            FROM   Billings
            WHERE  emp_name = h.emp_name AND bill_date <= h.work_date
        )
GROUP BY 1


-- Solution 2: using LEAD window function

WITH BillingWithNextDate AS (
    SELECT emp_name, 
           bill_date, 
           bill_rate, 
           LEAD(bill_date, 1, '9999-12-31') OVER (PARTITION BY emp_name ORDER BY bill_date) AS next_bill_date
    FROM   Billings
)
SELECT   h.emp_name, SUM(h.bill_hrs * b.bill_rate) AS totalcharges
FROM     HoursWorked h JOIN BillingWithNextDate b 
ON       h.emp_name = b.emp_name AND h.work_date BETWEEN b.bill_date AND b.next_bill_date
GROUP BY 1
```

