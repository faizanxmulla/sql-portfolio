### Problem Statement

Write an SQL query to find all couples of trades for the same stock that happened within a range of 10 seconds and have a price difference of more than 10%. 

The output result should also list the percentage of the price difference between the two trades.

### Schema Setup

```sql
CREATE TABLE trades (
  trade_id VARCHAR(20),
  trade_timestamp TIMESTAMP,
  trade_stock VARCHAR(50),
  quantity INT,
  price DECIMAL(10, 2)
);

INSERT INTO trades VALUES
('TRADE1', '10:01:05.000000', 'ITJunction4All', 100, 20),
('TRADE2', '10:01:06.000000', 'ITJunction4All', 20, 15),
('TRADE3', '10:01:08.000000', 'ITJunction4All', 150, 30),
('TRADE4', '10:01:09.000000', 'ITJunction4All', 300, 32),
('TRADE5', '10:10:00.000000', 'ITJunction4All', -100, 19),
('TRADE6', '10:10:01.000000', 'ITJunction4All', -300, 19);
```

### Expected Output

| first_trade | second_trade | first_trade_price | second_trade_price | percentdiff |
|-------------|--------------|-------------------|--------------------|-------------|
| TRADE1      | TRADE2       | 20                | 15                 | 25          |
| TRADE1      | TRADE3       | 20                | 30                 | 50          |
| TRADE1      | TRADE4       | 20                | 32                 | 60        |
| TRADE2      | TRADE3       | 15                | 30                |  100         |
| TRADE2      | TRADE4       | 15                | 32                 | 113.33        |

### Solution Query 

```sql
WITH CTE as (
    SELECT t1.trade_id, 
           t2.trade_id, 
           t1.price, 
           t2.price, 
           ABS(100.0 * (t1.price - t2.price) / t1.price) as percentdiff
    FROM   trades t1 JOIN trades t2 ON t1.trade_id < t2.trade_id
    WHERE  EXTRACT(EPOCH FROM t1.trade_timestamp - t2.trade_timestamp) <= 10
)
SELECT *
FROM   CTE
WHERE  percentdiff > 10
```