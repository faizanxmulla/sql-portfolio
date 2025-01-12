-- Solution 1: using LEFT JOIN

SELECT c.first_name
FROM   customers c LEFT JOIN orders o ON c.id=o.cust_id
WHERE  o.id IS NULL



-- Solution 2: using NOT IN 

SELECT first_name
FROM   customers
WHERE  id NOT IN (
    SELECT cust_id
    FROM   orders
)