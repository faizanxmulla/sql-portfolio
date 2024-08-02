### Problem statement

Find out the count of new customers visits and repeated customers visit along with the total amount spend by new customers and repeated customers seperately.

### Schema Setup

```sql
CREATE TABLE customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    order_date DATE,
    order_amount INTEGER
);

INSERT INTO customer_orders VALUES 
(1, 100, CAST('2022-01-01' AS DATE), 2000),
(2, 200, CAST('2022-01-01' AS DATE), 2500),
(3, 300, CAST('2022-01-01' AS DATE), 2100),
(4, 100, CAST('2022-01-02' AS DATE), 2000),
(5, 400, CAST('2022-01-02' AS DATE), 2200),
(6, 500, CAST('2022-01-02' AS DATE), 2700),
(7, 100, CAST('2022-01-03' AS DATE), 3000),
(8, 400, CAST('2022-01-03' AS DATE), 1000),
(9, 600, CAST('2022-01-03' AS DATE), 3000);
```

### Expected Output

order_date |	new_customers |	repeated_customers |	new_customers_order_amt | repeated_customers_order_amt |
--|--|--|--|--|
2022-01-01 |	3 |	0 |	6600 |	0 |
2022-01-02 |	2 |	1 |	4900 |	2000 |
2022-01-03 |	1 |	2 |	3000 |	4000 |


### Solution Query

```sql
WITH visits_cte AS (
	SELECT customer_id, 
		   order_date, 
		   order_amount,
		   LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_visit
	FROM   customer_orders
)
SELECT   order_date, 
         COUNT(customer_id) FILTER(WHERE prev_visit IS NULL) AS new_customers,
		 COUNT(customer_id) - COUNT(customer_id) FILTER(WHERE prev_visit IS NULL) AS repeated_customers, 
		 SUM(order_amount) FILTER(WHERE prev_visit IS NULL) AS new_customers_order_amt,
		 SUM(order_amount) - SUM(order_amount) FILTER(WHERE prev_visit IS NULL) AS repeated_customers_order_amt
FROM     visits_cte
GROUP BY 1
ORDER BY 1
```

