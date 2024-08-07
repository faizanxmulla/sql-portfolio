### Problem Statement | [Leetcode Link](https://leetcode.com/problems/total-sales-amount-by-year/description/)

Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name, and report_year.

Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.


### Schema Setup

```sql
CREATE TABLE product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

INSERT INTO product (product_id, product_name) VALUES
(1, 'LC Phone'),
(2, 'LC T-Shirt'),
(3, 'LC Keychain');


CREATE TABLE sales (
    product_id INT,
    period_start VARCHAR(20),
    period_end DATE,
    average_daily_sales INT
);

INSERT INTO sales (product_id, period_start, period_end, average_daily_sales) VALUES
(1, '2023-07-01', '2023-07-31', 150),
(2, '2023-06-01', '2023-06-30', 45),
(3, '2023-05-01', '2023-05-31', 2),
(1, '2023-01-01', '2023-01-31', 140),
(2, '2022-12-01', '2022-12-31', 60),
(3, '2023-02-01', '2023-02-28', 5);
```


### Solution Query

```sql
SELECT    b.product_id,
          a.product_name,
          a.yr AS report_year,
          CASE 
              WHEN YEAR(b.period_start) = YEAR(b.period_end) AND a.yr = YEAR(b.period_start) THEN DATEDIFF(b.period_end,b.period_start) + 1
              WHEN a.yr = YEAR(b.period_start) THEN DATEDIFF(DATE_FORMAT(b.period_start,'%Y-12-31'), b.period_start)+1
              WHEN a.yr = YEAR(b.period_end) THEN DAYOFYEAR(b.period_end) 
              WHEN a.yr > YEAR(b.period_start) AND a.yr < YEAR(b.period_end) THEN 365
              ELSE 0
          END * average_daily_sales AS total_amount
FROM (
      SELECT product_id,product_name,'2018' AS yr FROM Product
      UNION
      SELECT product_id,product_name,'2019' AS yr FROM Product
      UNION
      SELECT product_id,product_name,'2020' AS yr FROM Product
	) a
    JOIN Sales b ON a.product_id=b.product_id  
HAVING   total_amount > 0
ORDER BY 1, 3
```
