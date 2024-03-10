-- You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (item_count table) and the corresponding number of orders for each item count (order_occurrences table).


SELECT ROUND(SUM(item_count::decimal * order_occurrences) / SUM(order_occurrences), 1) as mean
FROM   items_per_order



-- other approaches: 

-- 1. 
ROUND((SUM(order_occurrences * item_count) / SUM(order_occurrences))::numeric, 1) AS mean

-- 2.
ROUND(CAST(SUM(item_count*order_occurrences) / SUM(order_occurrences) AS DECIMAL),1) AS mean






-- my approach:

-- mean #items per order
-- round to 1 

SELECT ROUND(SUM(item_count * order_occurrences) / SUM(order_occurrences), 1) as mean
FROM   items_per_order



-- remarks : both item_count and order_occurrences are of integer type by default, which means that division will return an integer result. To ensure that the output is rounded to 1 decimal place, we can cast either column to a decimal type.
