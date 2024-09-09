### Problem Statement 

Write SQL query to find cities where not even a single order was returned.

### Schema Setup

```sql
CREATE TABLE namaste_orders (
    order_id INT,
    city VARCHAR(10),
    sales INT
);

INSERT INTO namaste_orders VALUES 
(1, 'Mysore', 100),
(2, 'Mysore', 200),
(3, 'Bangalore', 250),
(4, 'Bangalore', 150),
(5, 'Mumbai', 300),
(6, 'Mumbai', 500),
(7, 'Mumbai', 800);


CREATE TABLE namaste_returns (
    order_id INT,
    return_reason VARCHAR(20)
);

INSERT INTO namaste_returns VALUES 
(3, 'wrong item'),
(6, 'bad quality'),
(7, 'wrong item');
```

### Expected Output

city_with_no_returns |
--|
Mysore |


### Solution Query

```sql
-- correct solution:

SELECT   no.city as city_with_no_returns
FROM     namaste_orders no LEFT JOIN namaste_returns nr USING(order_id)
GROUP BY 1
HAVING   COUNT(nr.order_id) = 0


-- Solution 2: using NOT IN

SELECT DISTINCT city
FROM   namaste_orders
WHERE  city NOT IN (
    SELECT no.city
    FROM   namaste_orders no JOIN namaste_returns nr USING(order_id)
)


-- my approach --> made mistake

SELECT DISTINCT city as city_with_no_returns
FROM   namaste_orders
WHERE  order_id NOT IN (
	SELECT order_id
	FROM   namaste_returns
)

-- similar approach; same mistake

SELECT no.city as city_with_no_returns
FROM   namaste_orders no JOIN namaste_returns nr USING(order_id)
WHERE  nr.order_id IS NULL
```

