### Problem Statement

Write a SQL query to find users who purchased different products on different dates. This means that products purchased on any given day are not repeated on any other day for a particular user.

### Schema Setup

```sql
CREATE TABLE purchase_history (
    user_id INT,
    product_id INT,
    purchase_date DATE
);

INSERT INTO purchase_history (user_id, product_id, purchase_date) VALUES
(1, 1, '2012-01-23'),
(1, 2, '2012-01-23'),
(1, 3, '2012-01-25'),
(2, 1, '2012-01-23'),
(2, 2, '2012-01-23'),
(2, 2, '2012-01-25'),
(2, 4, '2012-01-25'),
(3, 4, '2012-01-23'),
(3, 1, '2012-01-23'),
(4, 1, '2012-01-23'),
(4, 2, '2012-01-25');
```

### Expected Output

| user_id |
|--------|
| 1      |
| 4      |

### Solution Query

```sql
SELECT   user_id
FROM     purchase_history
GROUP BY user_id
HAVING   COUNT(distinct purchase_date) > 1 and COUNT(distinct product_id)=COUNT(product_id)
```

