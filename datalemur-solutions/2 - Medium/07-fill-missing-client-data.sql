WITH grouped_products AS (
         SELECT *,
                Count(category) OVER (ORDER BY product_id) AS category_group
         FROM   products)
SELECT product_id,
       CASE WHEN category IS NULL THEN First_value(category) OVER (partition BY category_group)
           ELSE category
       END AS category,
       name
FROM   grouped_products 