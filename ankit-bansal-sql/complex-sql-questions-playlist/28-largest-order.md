### Problem Statement

Find the largest order by value for each salesperson and display order details. Get the result without using subquery, CTE, window functions, or temp tables.

### Schema Setup

```sql
CREATE TABLE int_orders (
    order_number INT,
    order_date DATE,
    cust_id INT,
    salesperson_id INT,
    amount DECIMAL(10, 2)
);

INSERT INTO int_orders VALUES
(30, '1995-07-14', 9, 1, 460),
(10, '1996-08-02', 4, 2, 540),
(40, '1998-01-29', 7, 2, 2400),
(50, '1998-02-03', 6, 1, 600),
(60, '1998-03-02', 6, 7, 720),
(70, '1998-05-06', 9, 7, 150),
(20, '1999-01-30', 4, 8, 1800);
```

### Expected Output

| order_number | order_date | cust_id | salesperson_id | amount |
|--------------|------------|---------|----------------|--------|
| 20           | 1999-01-30 | 4       | 8              | 1800   |
| 30           | 1995-07-14 | 9       | 1              | 460    |
| 40           | 1998-01-29 | 7       | 2              | 2400   |
| 60           | 1998-03-02 | 6       | 7              | 720    |

### Solution Query

```sql
SELECT   a.order_number, 
         a.order_date, 
         a.cust_id, 
         a.salesperson_id,
         a.amount
FROM     int_orders a LEFT JOIN int_orders b ON a.salesperson_id=b.salesperson_id
GROUP BY 1, 2, 3, 4, 5
HAVING   a.amount >= MAX(b.amount)
ORDER BY 1
```