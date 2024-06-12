WITH combined_corpus AS (
    SELECT product_name, mrp
    FROM   innerwear_macys_com
    UNION ALL
    SELECT product_name, mrp
    FROM   innerwear_topshop_com
)
SELECT a.product_name, a.brand_name, a.price, a.rating
FROM   innerwear_amazon_com a LEFT JOIN combined_corpus c USING(product_name, mrp)
WHERE  c.product_name IS NULL


-- OR -- (same logic but different implementation)


SELECT product_name, brand_name, price, rating
FROM   innerwear_amazon_com
WHERE  (product_name, mrp) NOT IN (
                             SELECT product_name, mrp
                             FROM   innerwear_macys_com
                             UNION ALL
                             SELECT product_name, mrp
                             FROM   innerwear_topshop_com
                        )