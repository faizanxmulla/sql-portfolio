### Problem Statement

Write a query to fetch the records of brand whose amount is increasing every year. 


### Schema setup

```sql
-- Create the sales table
CREATE TABLE sales (
    Year INT,
    Brand VARCHAR(50),
    Amount INT
);

-- Insert the data into the sales table
INSERT INTO sales (Year, Brand, Amount) VALUES
(2018, 'Apple', 45000),
(2019, 'Apple', 35000),
(2020, 'Apple', 75000),
(2018, 'Samsung', 15000),
(2019, 'Samsung', 20000),
(2020, 'Samsung', 25000),
(2018, 'Nokia', 21000),
(2019, 'Nokia', 17000),
(2020, 'Nokia', 14000);
```

### Solution Query

```sql
-- Solution 1: my approach

WITH yearly_sales_comparison AS (
    SELECT *, 
           LEAD(amount) OVER(PARTITION BY brand ORDER BY year) AS next_year_amount, 
           LEAD(amount, 2) OVER(PARTITION BY brand ORDER BY year) AS year_after_next_amount  
    FROM   sales
)
SELECT *
FROM   yearly_sales_comparison
WHERE  next_year_amount > amount AND 
       year_after_next_amount > next_year_amount;


-- Solution 2: using flag

WITH cte AS (
    SELECT *, 
           CASE 
                WHEN amount < LEAD(amount, 1, amount + 1) OVER(PARTITION BY brand ORDER BY year) THEN 1
                ELSE 0
           END AS flag
    FROM   sales
)
SELECT *
FROM   sales
WHERE  brand NOT IN (
            SELECT brand 
            FROM   cte 
            WHERE  flag = 0
        )
```

