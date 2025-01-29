WITH unique_categ_per_order AS (
    SELECT   user_id,
             user_name,
             uo.order_id,
             COUNT(DISTINCT item_category) AS unique_item_cat_count
    FROM     user_orders uo JOIN ordered_items oi USING(order_id)
    GROUP BY 1, 2, 3
)
SELECT   user_name,
         ROUND(AVG(unique_item_cat_count), 1) AS avg_unique_item_categories_per_order
FROM     unique_categ_per_order
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1
