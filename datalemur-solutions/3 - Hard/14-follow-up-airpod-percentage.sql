-- The Apple retention team needs your help to investigate buying patterns. 

-- Write a query to determine the percentage of buyers who bought AirPods directly after they bought iPhones. 
-- Round your answer to a percentage (i.e. 20 for 20%, 50 for 50) with no decimals.

-- Clarifications:

-- The users were interested in buying iPhones and then AirPods, with no intermediate purchases in between.
-- Users who buy iPhones and AirPods at the same time, with the iPhone logged first, can still be counted.
-- Tip:

-- Multiply by 100 before you perform the rounding to make sure you get the same answer we did :)


-- transactions Table:

-- Column Name	Type
-- transaction_id	integer
-- customer_id	integer
-- product_name	varchar
-- transaction_timestamp	datetime


-- transactions Example Input:

-- transaction_id	customer_id	product_name	transaction_timestamp
-- 1	101	iPhone	08/08/2022 00:00:00
-- 2	101	AirPods	08/08/2022 00:00:00
-- 5	301	iPhone	09/05/2022 00:00:00
-- 6	301	iPad	09/06/2022 00:00:00
-- 7	301	AirPods	09/07/2022 00:00:00


-- Example Output:
-- follow_up_percentage
-- 50


-- Explanation:

-- Of the two users, only user 101 bought AirPods after buying an iPhone.

-- Note that we still count user 101, even though they bought both an iPhone and AirPods in the same transaction. We can't count customer 301 since they bought an iPad in between their iPhone and AirPods.

-- Therefore, 1 out of 2 users fit the problem's criteria. For this example, the follow-up percentage would be 50%.



WITH transaction_cte AS (
    SELECT customer_id,
           product_name,
           LEAD(product_name) OVER(PARTITION BY customer_id ORDER BY transaction_timestamp) AS next_product
    FROM   transactions
)
SELECT ROUND(100.0 * 
                COUNT(DISTINCT CASE WHEN product_name = 'iPhone' AND next_product = 'AirPods' THEN customer_id END) /
                COUNT(DISTINCT CASE WHEN product_name = 'iPhone' THEN customer_id END)
            ) AS follow_up_percentage
FROM transaction_cte;



-- also found this solution: 

-- ISSUE with this:  

-- It assumes that if rn = 2 and the product is AirPods, it should be counted.

-- However, it does not ensure that the first product (rn = 1) is an iPhone. Therefore, it might include cases where AirPods is bought after a different product, not necessarily an iPhone.


WITH transaction_cte AS (
    SELECT customer_id,
           product_name, 
           ROW_NUMBER() OVER(PARTITION BY customer_id 
                             ORDER BY transaction_timestamp) as rn
    FROM   transactions
)
SELECT ROUND(100.0 * 
             	SUM(CASE WHEN rn = 2 AND product_name = 'AirPods' 
                         THEN 1 ELSE 0 END) /
                COUNT(DISTINCT customer_id)
            ) AS follow_up_pct
FROM   transaction_cte
WHERE  rn < 3


