### Problem Statement

Find how many products fall within each customer's budget along with the list of products. In case of a clash, choose the less costly product.

### Schema Setup

```sql
CREATE TABLE products (
    product_id VARCHAR(10),
    cost INT
);

CREATE TABLE customer_budget (
    customer_id INT,
    budget INT
);

INSERT INTO products (product_id, cost) VALUES
('P1', 200),
('P2', 300),
('P3', 500),
('P4', 800);

INSERT INTO customer_budget (customer_id, budget) VALUES
(100, 400),
(200, 800),
(300, 1500);
```

### Expected Output

| customer_id | no_of_products | list_of_products   |
|-------------|----------------|--------------------|
| 100         | 1              | P1                 |
| 200         | 2              | P1, P2             |
| 300         | 3              | P1, P2, P3         |

### Solution Query

```sql
WITH CTE AS (
    SELECT *,  SUM(cost) OVER (ORDER BY cost) as cumulative_cost
    FROM   products
)
SELECT   customer_id, 
         COUNT(product_id) as no_of_products, 
         STRING_AGG(product_id, ', ') as list_of_products
FROM     customer_budget JOIN CTE ON cumulative_cost <= budget
GROUP BY 1
ORDER BY 1
```

