### Problem Statement

There is a live production system with a table ("orders") that captures order information in real-time. We wish to capture "deltas" from this table (inserts and deletes) by leveraging a nightly copy of the table. 

There are no timestamps that can be used for delta processing.

**order** - order_ID (Primary Key)

This table processes 10,000 transactions per day, including INSERTs, UPDATEs, and DELETEs. The DELETEs are physical, so the records will no longer exist in the table.

Every day at 12:00 AM, a snapshot (copy) of this table is created and is an exact copy of the table at that time.

**order_copy**  - order_ID (Primary Key)

**Requirement:**

Write a query that *(as efficiently as possible)* will return only new INSERTs into `order` since the snapshot was taken (record is in `order`, but not `order_copy`) OR only new DELETEs from `order` since the snapshot was taken (record is in `order_copy`, but not `order`).


The query should return the Primary Key (`ORDER_ID`) and a single character (`INSERT_OR_DELETE_FLAG`) of `"I"` if it is an INSERT, or `"D"` if it is a DELETE.


| ORDER_ID | INSERT_OR_DELETE_FLAG |
|----------|-----------------------|
| 1234     | "D"                   |
| 5678     | "I"                   |


**Rule**: Not to use `minus`, `union`, `merge`, `union all`... `exist` and `not exist` can be used.



### Schema Setup

```sql
CREATE TABLE orders (
    order_id INTEGER,
    order_date DATE
);

INSERT INTO orders(order_id, order_date)VALUES 
(1, '2022-10-21'),
(2, '2022-10-22'),
(3, '2022-10-25'),
(4, '2022-10-25');

SELECT * 
INTO   orders_copy 
FROM   orders;

SELECT * 
FROM   orders;

INSERT INTO orders (order_id, order_date) VALUES 
(5, '2022-10-26'),
(6, '2022-10-26');

DELETE 
FROM   orders 
WHERE  order_id = 1;
```


### Expected Output

order_id | insert_or_delete_flag |
--|--|
1  |D |
5  |I |
6  |I |

### Solution

```sql
SELECT COALESCE(o.order_id, oc.order_id) as order_id, 
	   CASE WHEN oc.order_id IS NULL THEN 'I' 
			WHEN o.order_id IS NULL THEN 'D' 
	   END AS insert_or_delete_flag       
FROM   orders o FULL OUTER JOIN orders_copy oc USING(order_id)
WHERE  o.order_id IS NULL or oc.order_id IS NULL
```