### Problem Statement

Write a SQL query to find the price at the start of each month for a given SKU and calculate the difference from the previous month's price.


### Schema Setup

```sql
CREATE TABLE prices (
    sku_id INT,
    date DATE,
    price INT
);

INSERT INTO prices (sku_id, date, price) VALUES
(1, '2023-01-01', 10),
(1, '2023-02-15', 15),
(1, '2023-03-03', 18),
(1, '2023-03-27', 15),
(1, '2023-04-06', 20);
```

### Expected Output

| SKU | date       | price | diff |
|-----|------------|-------|------|
| 1   | 2023-01-01 | 10    | 0    |
| 1   | 2023-02-01 | 10    | 0    |
| 1   | 2023-03-01 | 15    | 5    |
| 1   | 2023-04-01 | 15    | 0    |
| 1   | 2023-05-01 | 20    | 5    |


### Solution Query

```sql
WITH dates_cte as (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY sku_id, TO_CHAR(date, 'YYYY-MM') ORDER BY date desc) as rn
	FROM   prices
), 
price_at_start_cte as (
	SELECT sku_id, date, price
	FROM   prices
	WHERE  EXTRACT(DAY FROM date) = 1
	UNION ALL
	SELECT sku_id, DATE_TRUNC('month', date + INTERVAL '1 month') as next_month, price
	FROM   dates_cte
	WHERE  rn=1
)
SELECT sku_id, date, price, COALESCE(price - LAG(price) OVER(PARTITION BY sku_id ORDER BY date), 0) as diff 
FROM   price_at_start_cte
```