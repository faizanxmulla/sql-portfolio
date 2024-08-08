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
    period_start DATE,
    period_end DATE,
    average_daily_sales INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Sales (product_id, period_start, period_end, average_daily_sales) VALUES
(1, '2019-01-25', '2019-02-28', 100),
(2, '2018-12-01', '2020-01-01', 10),
(3, '2019-12-01', '2020-01-31', 1);
```

### Expected Output


| product_id | report_year | total_amount |
|------------|-------------|--------------|
| 1          |    2019     | 3500         |
| 2          |    2018     | 310          |
| 2          |    2019     | 3650         |
| 2          |    2020     | 10           |
| 3          |    2019     | 31           |
| 3          |    2020     | 31           |



### Solution Query

```sql
-- easy solution using RECURSIVE CTE.

WITH RECURSIVE all_dates AS (
    SELECT MIN(period_start) as dates, MAX(period_end) as max_date
    FROM   sales
    UNION ALL
    SELECT dates + 1 as dates, max_date
    FROM   all_dates
    WHERE  dates < max_date
)
SELECT   product_id, 
         EXTRACT(YEAR FROM dates) as report_year, 
         SUM(average_daily_sales) as total_amount
FROM     all_dates ad JOIN sales s ON dates BETWEEN period_start AND period_end 
GROUP BY 1, 2
ORDER BY 1, 2
```
