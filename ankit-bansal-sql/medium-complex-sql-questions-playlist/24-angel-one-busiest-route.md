### Problem Statement

Write a query to find the busiet route along with the total ticket count.

*Column Description*: `oneway_round`

- 'O' --> One Way Trip

- 'R' --> Round Trip

**NOTE**: `DEL -> BOM` is a different toute from `BOM -> DEL`



### Schema Setup

```sql
CREATE TABLE tickets (
    airline_number VARCHAR(10),
    origin VARCHAR(3),
    destination VARCHAR(3),
    oneway_round CHAR(1),
    ticket_count INT
);

INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count) VALUES
('DEF456', 'BOM', 'DEL', 'O', 150),
('GHI789', 'DEL', 'BOM', 'R', 50),
('JKL012', 'BOM', 'DEL', 'R', 75),
('MNO345', 'DEL', 'NYC', 'O', 200),
('PQR678', 'NYC', 'DEL', 'O', 180),
('STU901', 'NYC', 'DEL', 'R', 60),
('ABC123', 'DEL', 'BOM', 'O', 100),
('VWX234', 'DEL', 'NYC', 'R', 90);
```


### Expected Output

busiest_route |	total_ticket_count |
--|--|
DEL → NYC |	350 |


### Solution

```sql
-- Solution 

WITH CTE AS (
	SELECT origin, destination, ticket_count, oneway_round
	FROM   tickets
	UNION ALL
	SELECT destination, origin, ticket_count, oneway_round
	FROM   tickets
	WHERE  oneway_round='R'
)
SELECT   CONCAT(origin, ' → ', destination) AS busiest_route, SUM(ticket_count) as total_ticket_count
FROM     CTE
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1



-- my initial approach: WRONG // didn't read the NOTE.

WITH CTE as (
	SELECT *, CASE WHEN oneway_round='R' THEN 2*ticket_count ELSE ticket_count END as total_ticket_count
	FROM   tickets
)
SELECT   airline_number, CONCAT(origin, ' → ', destination) as busiet_route
FROM     CTE
ORDER BY total_ticket_count desc
LIMIT    1
```
