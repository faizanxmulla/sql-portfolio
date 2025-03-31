## Above Average Product Prices

### Problem Statement 

Given a table of transactions and products, write a query to return the product ID, product price, and average transaction price of all products with a price greater than the average transaction price.

### Schema setup 

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    price DECIMAL(10, 2)
);

INSERT INTO products (product_id, price) VALUES
(1, 100.00),
(2, 150.00),
(3, 75.00),
(4, 200.00),
(5, 120.00);


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO transactions (transaction_id, product_id, amount) VALUES
(1, 1, 95.00),
(2, 1, 98.00),
(3, 2, 145.00),
(4, 2, 150.00),
(5, 3, 70.00),
(6, 4, 190.00),
(7, 4, 195.00),
(8, 5, 115.00);
```

### Expected Output 

product_id |	product_price |	avg_transaction_value |
--|--|--|
2 |	150.00 |	132.25 |
4 |	200.00 |	132.25 |


### Solution Query 

```sql
-- correct solution (according the result set):

WITH avg_transactions as (
    SELECT AVG(amount) as avg_transaction_value 
    FROM   transactions
)
SELECT p.product_id, 
       p.price as product_price, 
       at.avg_transaction_value
FROM   products p JOIN avg_transactions at ON p.price > at.avg_transaction_value



-- initial attempt:

WITH cte as (
    SELECT product_id, price as product_price
    FROM   products
    WHERE  price > (SELECT AVG(amount) FROM transactions)
)
SELECT c.product_id, c.product_price, AVG(t.amount) as avg_transaction_value
FROM   cte c JOIN transactions t ON c.product_id=t.product_id
GROUP BY c.product_id, c.product_price
```