## Product Sales by Month

### Problem Statement 

Given a table containing data for monthly sales, write a query to find the total amount of each product sold for each month, with each product as its own column in the output table.


### Schema setup 

```sql
CREATE TABLE monthly_sales (
    month DATE,
    product_id INTEGER,
    amount_sold INTEGER
);

INSERT INTO monthly_sales (month, product_id, amount_sold) VALUES
('2021-01-01', 1, 100),
('2021-01-01', 2, 300),
('2021-02-01', 1, 150),
('2021-02-01', 1, 50),
('2021-02-01', 2, 250),
('2021-03-01', 1, 120),
('2021-03-01', 4, 250),
('2021-04-01', 2, -30),
('2021-04-01', 3, 200),
('2021-05-01', 3, 175),
('2021-06-01', 1, 0),
('2021-06-01', 2, 100);
```

### Expected Output 

month |	product_1 |	product_2 |	product_3 |	product_4 |
--|--|--|--|--|
2021-01-01 |	100 |	300 |	0 |	0 |
2021-02-01 |	200 |	250 |	0 |	0 |
2021-03-01 |	120 |	0 |	0 |	250 |
2021-04-01 |	0 |	-30 |	200 |	0 |
2021-05-01 |	0 |	0 |	175 |	0 |
2021-06-01 |	0 |	100 |	0 |	0 |


### Solution Query 

```sql
SELECT   month,
         SUM(CASE WHEN product_id=1 THEN amount_sold ELSE 0 END) as product_1,
         SUM(CASE WHEN product_id=2 THEN amount_sold ELSE 0 END) as product_2,
         SUM(CASE WHEN product_id=3 THEN amount_sold ELSE 0 END) as product_3,
         SUM(CASE WHEN product_id=4 THEN amount_sold ELSE 0 END) as product_4
FROM     monthly_sales
GROUP BY month
ORDER BY month
```