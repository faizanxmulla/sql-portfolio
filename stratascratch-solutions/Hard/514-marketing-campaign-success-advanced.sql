-- Solution 1: 

WITH marketing_list AS (
    SELECT user_id,
           MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date,
           MIN(created_at) OVER(PARTITION BY user_id, product_id) AS first_product_purchase_date
    FROM   marketing_campaign
)
SELECT COUNT(DISTINCT user_id)
FROM   marketing_list
WHERE  first_purchase_date <> first_product_purchase_date



-- Solution 2: answer coming out as 24. (answer is 23)

-- WITH purchase_cte AS (
--     SELECT   user_id, MIN(created_at) as first_purchase
--     FROM     marketing_campaign
--     GROUP BY 1
--     ORDER BY 1
-- ),
-- subsequent_purchases AS (
--     SELECT user_id, product_id, created_at, first_purchase
--     FROM   marketing_campaign JOIN purchase_cte USING(user_id)
--     WHERE  created_at > first_purchase
-- )
-- SELECT COUNT(DISTINCT sp.user_id) AS count
-- FROM   subsequent_purchases sp JOIN marketing_campaign mc ON sp.user_id=mc.user_id AND 
--                                                              mc.created_at = sp.first_purchase AND
--                                                              mc.product_id <> sp.product_id