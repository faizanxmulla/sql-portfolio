WITH ranked_products as (
    SELECT   p.prod_sku_id,
             p.market_name,
             COUNT(*) AS n_orders,
             RANK() OVER(ORDER BY COUNT(*) desc) as rn
    FROM     map_product_order m JOIN shopify_orders o ON m.order_id = o.order_id
                                 JOIN shopify_users u ON o.user_id = u.id
                                 JOIN dim_product p ON m.product_id = p.prod_sku_id
    WHERE    u.country ILIKE 'Germany'
    GROUP BY 1, 2
)
SELECT market_name
FROM   ranked_products
WHERE  rn = 1



-- NOTE: main thing was to figure out was the joins and their conditions.