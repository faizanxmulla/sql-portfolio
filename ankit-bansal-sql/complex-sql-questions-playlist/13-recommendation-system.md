### Problem Statement

Write an SQL query to find all pairs of products that are purchased together by the same customer in the same order. 

For each pair, return the product names and the frequency with which the pair was purchased together.

### Schema Setup

```sql
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    product_id INT
);

INSERT INTO orders (order_id, customer_id, product_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 1),
(5, 2, 2);


CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO products (id, name) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');
```

### Expected Output

| pair | purchase_freq |
|------|---------------|
| A B  | 2             |
| A C  | 1             |
| B C  | 1             |
| A D  | 1             |
| B D  | 1             |



### Solution Query 

```sql
SELECT   CONCAT(pr1.name, ' ' , pr2.name) AS pair, COUNT(*) AS purchase_freq 
FROM     orders o1 JOIN orders o2 ON o1.order_id = o2.order_id 
                   JOIN products pr1 ON pr1.id = o1.product_id 
                   JOIN products pr2 ON pr2.id = o2.product_id
WHERE    o1.product_id < o2.product_id
GROUP BY 1
```