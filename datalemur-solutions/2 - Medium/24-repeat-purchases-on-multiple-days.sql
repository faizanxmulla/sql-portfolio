WITH purchases_by_users AS (
    SELECT  *, 
            DENSE_RANK() OVER(PARTITION BY user_id, product_id ORDER BY DATE(purchase_date)) AS num_purchases
    FROM    purchases
)
SELECT COUNT(DISTINCT user_id) AS users_num
FROM   purchases_by_users
WHERE  num_purchases > 1