## Data Cleaning & Transformation

### Table 1 : `customer_orders`

Upon observing the `customer_orders` table below, we can see that there are :

- Missing values ' ' and null values in the `exclusions` column.

- Missing values ' ' and null values in the `extras` column.

Result set **before removing null values** : 

![before cleaning](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/5fe46968-d22d-41b6-b0ce-625c89386f52)


In order to remove these values, we will:

- Create a temporary table with all the columns. 

- Remove null values in both the `exclusions` and `extras` columns and replace them with blank space ' '.


```sql
CREATE TEMP TABLE temp_customer_orders AS
SELECT
  order_id,
  customer_id,
  pizza_id,
  CASE
    WHEN exclusions = '' OR exclusions = 'null' THEN NULL
    ELSE exclusions
  END AS exclusions,
  CASE
    WHEN extras = '' OR extras = 'null' THEN NULL
    ELSE extras
  END AS extras,
  order_time
FROM
  pizza_runner.customer_orders;

SELECT * 
FROM   temp_customer_orders;
```

#### Result set:

![1](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/5030fd34-061e-4af7-8e42-41be49046ec8)


---


### Table 2 : `runner_orders`

- The columns for pickup_time, distance, duration, and cancellation within the runner_orders table require cleaning prior to their utilization in queries.

- The pickup_time column includes missing values.

- Missing values are present in the distance column, which also features the unit "km" that needs to be removed.

- The duration column is not only missing values but also contains the terms "minutes", "mins", and "minute" that should be eliminated.

- Both blank spaces and missing values are found in the cancellation column.


```sql
DROP TABLE IF EXISTS temp_runner_orders;
CREATE TEMPORARY TABLE temp_runner_orders AS

SELECT order_id,
       runner_id,
       CASE
           WHEN pickup_time LIKE 'null' THEN NULL
           ELSE pickup_time
       END AS pickup_time,
       CASE
           WHEN distance LIKE 'null' THEN NULL
           ELSE CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
       END AS distance,
       CASE
           WHEN duration LIKE 'null' THEN NULL
           ELSE CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
       END AS duration,
       CASE
           WHEN cancellation LIKE '' THEN NULL
           WHEN cancellation LIKE 'null' THEN NULL
           ELSE cancellation
       END AS cancellation
FROM   runner_orders;

SELECT * 
FROM   temp_runner_orders;
```


#### Result set:

![2](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/073a0073-192f-42c9-a356-ddf753877ec3)

---
