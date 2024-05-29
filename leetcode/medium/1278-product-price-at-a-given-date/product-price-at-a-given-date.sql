WITH products_cte AS (
    SELECT DISTINCT product_id
    FROM   Products
),
ranked_products AS (
    SELECT product_id, 
           new_price, 
           DENSE_RANK() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS dr
    FROM   Products
    WHERE  change_date <= '2019-08-16'
)
SELECT p.product_id, 
       COALESCE(rp.new_price, 10) AS price
FROM   products_cte p LEFT JOIN ranked_products rp USING(product_id)
WHERE  dr=1 OR dr IS NULL