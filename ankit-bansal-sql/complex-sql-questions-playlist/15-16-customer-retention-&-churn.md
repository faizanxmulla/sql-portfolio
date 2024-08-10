### Problem Statement

How can you calculate customer retention and churn rates using SQL when only the last 2 months of data are available? 

Consider that customer retention refers to customers who made a purchase in both months, while churn refers to customers who made a purchase in the first month but not in the second. 

**Details:**
- Retention programs like Zomato Pro, Cashbacks, and Reward Programs are in place, and you need to build metrics to evaluate their effectiveness.

- Use the available 2-month transaction data to determine customer retention and churn.


### Schema Setup

```sql
CREATE TABLE transactions (
    order_id INT,
    cust_id INT,
    order_date DATE,
    amount INT
);

INSERT INTO transactions (order_id, cust_id, order_date, amount) VALUES 
(1, 1, '2020-01-15', 150),
(2, 1, '2020-02-10', 150),
(3, 2, '2020-01-16', 150),
(4, 2, '2020-02-25', 150),
(5, 3, '2020-01-10', 150),
(6, 3, '2020-02-20', 150),
(7, 4, '2020-01-20', 150),
(8, 5, '2020-02-20', 150);
```

### Expected Output

*Retained Customers count :* 

month |	retained_customers |
--|--|
1 |	0 |
2 |	3 |

*Churned Customers count :* 

churned_customers |
--|
1 |

### Solution Query

```sql
-- Retention rate

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY order_date) as rn
    FROM   transactions
)
SELECT   EXTRACT(MONTH FROM order_date) as month, COUNT(CASE WHEN rn=2 THEN cust_id ELSE null END) AS retained_customers
FROM     CTE
GROUP BY 1


-- Churn customers

WITH CTE AS (
    SELECT cust_id, 
           EXTRACT(MONTH FROM order_date) AS month,
           ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY order_date) AS rn,
           COUNT(*) OVER(PARTITION BY cust_id) AS order_count
    FROM   transactions
)
SELECT COUNT(DISTINCT cust_id) AS churned_customers
FROM   CTE
WHERE  month=1 AND order_count=1
```