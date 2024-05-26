-- You are trying to find the median number of items bought per order on Alibaba, rounded to 1 decimal point.

-- However, instead of doing analytics on all Alibaba orders, you have access to a summary table, which describes how many items were in an order, and the number of orders that had that many items.

-- items_per_order Table:

-- Column Name	Type
-- item_count	integer
-- order_occurrences	integer

-- items_per_order 

-- Example Input:
-- item_count	order_occurrences
-- 1	500
-- 2	1000
-- 3	800
-- 4	1000

-- Example Output:

-- median
-- 3.0

-- Explanation:

-- The total orders in the order_occurrences field in this dataset is 3300, meaning that the median item count 
-- would be for the 1650th order (3300 / 2 = 1650).
-- If we compare this to the running sum of order_occurrences, we can see that the median item count is 3.



WITH order_summary AS (
    SELECT item_count, 
           order_occurrences,
           SUM(order_occurrences) OVER (ORDER BY item_count) AS running_total
    FROM   items_per_order
),
total_orders AS (
    SELECT SUM(order_occurrences) AS total_orders
    FROM   items_per_order
)
SELECT   ROUND(item_count::numeric, 1) AS median
FROM     order_summary os, total_orders t
WHERE    running_total >= t.total_orders / 2.0
ORDER BY running_total
LIMIT    1