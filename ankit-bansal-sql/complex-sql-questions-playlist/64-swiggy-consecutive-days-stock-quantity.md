### Problem Statement

Write a SQL query to find out `supplier_id`, `product_id`, `no_of_days`, and the starting date of `record_date` for which stock quantity is less than 50 for two or more consecutive days.


### Schema Setup 

```sql
CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

INSERT INTO stock VALUES
(1, 1, 60, '2022-01-01'),
(1, 1, 40, '2022-01-02'),
(1, 1, 35, '2022-01-03'),
(1, 1, 45, '2022-01-04'),
(1, 1, 51, '2022-01-06'),
(1, 1, 55, '2022-01-09'),
(1, 1, 25, '2022-01-10'),
(1, 1, 48, '2022-01-11'),
(1, 1, 45, '2022-01-15'),
(1, 1, 38, '2022-01-16'),
(1, 2, 45, '2022-01-08'),
(1, 2, 40, '2022-01-09'),
(2, 1, 45, '2022-01-06'),
(2, 1, 55, '2022-01-07'),
(2, 2, 45, '2022-01-08'),
(2, 2, 48, '2022-01-09'),
(2, 2, 35, '2022-01-10'),
(2, 2, 52, '2022-01-15'),
(2, 2, 23, '2022-01-16');
```

### Expected Output

| supplier_id | product_id | no_of_days | first_date  |
|-------------|------------|------------|-------------|
| 1           | 1          | 3          | 2022-01-02  |
| 1           | 1          | 2          | 2022-01-10  |
| 1           | 1          | 2          | 2022-01-15  |
| 1           | 2          | 2          | 2022-01-08  |
| 2           | 2          | 3          | 2022-01-08  |




### Solution Query

```sql
WITH low_stock AS (
	SELECT *, record_date - LAG(record_date, 1) OVER(PARTITION BY supplier_id, product_id ORDER BY record_date) AS date_diff
	FROM   stock
	WHERE  stock_quantity < 50
),
grouped_low_stock AS (
  SELECT supplier_id, product_id, record_date,
         SUM(CASE WHEN date_diff IS NULL OR date_diff > 1 THEN 1 ELSE 0 END) OVER(PARTITION BY supplier_id, product_id ORDER BY record_date) AS group_id
  FROM  low_stock
)
SELECT   supplier_id, product_id, COUNT(*) AS no_of_days, MIN(record_date) AS first_date
FROM     grouped_low_stock
GROUP BY supplier_id, product_id, group_id
HAVING COUNT(*) >= 2



-- my initial approach:

SELECT supplier_id, 
	   product_id, 
	   record_date, 
	   ROW_NUMBER() OVER() as rn, 
	   ROW_NUMBER() OVER(PARTITION BY supplier_id, product_id) as rn_2
FROM   stock 
WHERE  stock_quantity < 50
```