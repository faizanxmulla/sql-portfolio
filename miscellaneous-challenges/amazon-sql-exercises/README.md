## Amazon SQL exercises

### Questions

1. How many units were ordered yesterday?

2. In the last 7 days (including today), how many units were ordered in each category?

3. Write a query to get the earliest order_id for all customers for each date they placed an order.

4. Write a query to find the second earliest order_id for each customer for each date they placed two or more orders.

---
---

### Solutions

#### 1. How many units were ordered yesterday?

```SQL
SELECT SUM(order_quantity) AS units_ordered_yesterday
FROM   orders
WHERE  DATE(order_datetime) = DATE(NOW()) - INTERVAL '1 DAY'


-- can also do this instead: EXTRACT(DAY FROM order_datetime) = EXTRACT (DAY FROM CURRENT_DATE) - 1
```

---

#### 2. In the last 7 days (including today), how many units were ordered in each category?


```SQL
SELECT   i.item_category, SUM(o.order_quantity) AS total_units_ordered
FROM     orders o JOIN items i USING(item_id)
WHERE    DATE(o.order_datetime) BETWEEN DATE(NOW()) - INTERVAL '6 DAY' AND DATE(NOW())
GROUP BY 1


-- can also do this instead: order_datetime::DATE BETWEEN CURRENT_DATE - 6 AND CURRENT_DATE
```

---

#### 3. Write a query to get the earliest order_id for all customers for each date they placed an order.

```SQL
-- Solution 1: using MIN()

SELECT   customer_id, 
	     order_datetime::date AS order_date, 
	     MIN(order_id) AS earliest_order_id
FROM     orders
GROUP BY 1, 2
ORDER BY 1, 2


-- Solution 2: using ROW_NUMBER()

WITH CTE AS(
    SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id, order_datetime::date ORDER BY order_datetime) as rn
    FROM   orders
)
SELECT customer_id, order_datetime::date AS order_date, order_id AS earliest_order_id
FROM   CTE
WHERE  rn = 1
```

---

#### 4. Write a query to find the second earliest order_id for each customer for each date, where they placed atleast two orders.

```SQL
WITH CTE AS (
    SELECT *, 
	       ROW_NUMBER() OVER(PARTITION BY customer_id, order_datetime::date ORDER BY order_datetime) as rn,              
	       COUNT(*) OVER (PARTITION BY customer_id, order_datetime::date) AS order_count
    FROM   orders
)
SELECT customer_id, order_datetime::date, order_id
FROM   CTE
WHERE  rn = 2 and order_count >= 2
```

---


### Reference / Link: 

- [najirh Github](https://github.com/najirh/100_days_challenge_community/blob/main/Day7.sql)