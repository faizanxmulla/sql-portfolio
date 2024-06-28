WITH ranked_orders AS (
    SELECT u.user_id, favorite_brand, item_brand,
           RANK() OVER(PARTITION BY o.seller_id ORDER BY o.order_date) AS rn
    FROM   users u LEFT JOIN orders o ON u.user_id = o.seller_id
                   LEFT JOIN items i ON o.item_id = i.item_id
)
SELECT   u.user_id AS seller_id,
         COALESCE(
              MAX(CASE 
              WHEN r.rn = 2 AND r.favorite_brand = r.item_brand THEN 'yes'
              WHEN r.rn IS NULL OR r.rn < 2 THEN 'no'
              END), 'no'
         ) AS "2nd_item_fav_brand"
FROM     users u LEFT JOIN ranked_orders r USING(user_id)
GROUP BY 1



-- my initial approach: 

WITH ranked_orders AS (
    SELECT *, 
           COUNT(i.item_id) OVER(PARTITION BY user_id) AS items_sold,
           RANK() OVER(PARTITION BY user_id ORDER BY order_date) AS rn
    FROM   users u LEFT JOIN orders o ON u.user_id=o.seller_id 
                   LEFT JOIN items i ON o.item_id=i.item_id
)
SELECT user_id AS seller_id,
       CASE WHEN item_brand=favorite_brand AND rn=2 THEN 'yes'
            WHEN items_sold < 2 THEN 'no'
            ELSE 'NO'
       END AS "2nd_item_fav_brand"
FROM   ranked_orders


