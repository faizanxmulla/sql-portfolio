### Problem Statement

You are given a transaction table, which records transactions between sellers and buyers. The structure of the table is as follows:

Transaction_ID (INT), Customer_ID (INT), Amount (INT), Date (timestamp)

Every successful transaction will have two row entries into the table with two different transaction_id but in ascending order sequence, the first one for the seller where their customer_id will be registered, and the second one for the buyer where their customer_id will be registered. The amount and date_time for both will however be the same.

**Write an SQL query to find the top 5 seller-buyer combinations who have had maximum transactions between them.**

Condition:

- Disqualify the sellers who have acted as buyers.
- Disqualify the buyers who have acted as sellers.


### Schema Setup

```sql
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_date DATETIME
);

DELETE FROM transactions;

INSERT INTO transactions (transaction_id, customer_id, amount, tran_date) VALUES
(1, 101, 500, '2025-01-01 10:00:01'),
(2, 201, 500, '2025-01-01 10:00:01'),
(3, 102, 300, '2025-01-02 00:50:01'),
(4, 202, 300, '2025-01-02 00:50:01'),
(5, 101, 700, '2025-01-03 06:00:01'),
(6, 202, 700, '2025-01-03 06:00:01'),
(7, 103, 200, '2025-01-04 03:00:01'),
(8, 203, 200, '2025-01-04 03:00:01'),
(9, 101, 400, '2025-01-05 00:10:01'),
(10, 201, 400, '2025-01-05 00:10:01'),
(11, 101, 500, '2025-01-07 10:10:01'),
(12, 201, 500, '2025-01-07 10:10:01'),
(13, 102, 200, '2025-01-03 10:50:01'),
(14, 202, 200, '2025-01-03 10:50:01'),
(15, 103, 500, '2025-01-01 11:00:01'),
(16, 101, 500, '2025-01-01 11:00:01'),
(17, 203, 200, '2025-11-01 11:00:01'),
(18, 201, 200, '2025-11-01 11:00:01');
```

### Expected Output

seller |	buyer |	transactions_count |
--|--|--|
102 |	202 |	2 |


### Solution

```sql
WITH transactions_cte as (
    SELECT   t1.customer_id as seller, 
             t2.customer_id as buyer,
             COUNT(*) as transactions_count
    FROM     transactions t1 JOIN transactions t2
    ON       t1.amount=t2.amount
             and t1.tran_date=t2.tran_date
             and t1.customer_id!=t2.customer_id
    WHERE    t1.transaction_id < t2.transaction_id
    GROUP BY t1.customer_id, t2.customer_id
)
, get_frauds as (
    SELECT seller as fraud_customer_id
    FROM   transactions_cte
    INTERSECT 
    SELECT buyer
    FROM   transactions_cte
)
SELECT   seller, buyer, transactions_count
FROM     transactions_cte
WHERE    seller NOT IN (SELECT fraud_customer_id FROM get_frauds)
         and buyer NOT IN (SELECT fraud_customer_id FROM get_frauds)
ORDER BY transactions_count desc
LIMIT    5
```

