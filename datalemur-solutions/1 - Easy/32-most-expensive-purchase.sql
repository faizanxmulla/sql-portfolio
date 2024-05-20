-- Amazon is trying to identify their high-end customers. To do so, they first need your help to write a query that obtains the most expensive purchase made by each customer. 

-- Order the results by the most expensive purchase first.

-- transactions Table:
-- Column Name	Type
-- transaction_id	integer
-- customer_id	integer
-- purchase_amount	integer

-- transactions Example Input:
-- transaction_id	customer_id	purchase_amount
-- 1	1	150
-- 2	1	35.90
-- 3	2	349.99
-- 4	2	199.95
-- 5	2	551.20
-- 6	3	13.30

-- Example Output:
-- customer_id	purchase_amount
-- 2	551.20
-- 1	150
-- 3	13.30



-- Solution: 

SELECT   customer_id, MAX(purchase_amount) as purchase_amount
FROM     transactions
GROUP BY 1
ORDER BY 2 DESC 