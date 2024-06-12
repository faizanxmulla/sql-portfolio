-- GB PRODUCT_FAMILY
-- SUM(units_sold) AS total_units_sold
-- percentage --> units sold w/ promotion / total_units_sold
-- COALESCE(, 0) --> REPLACE nulls
-- valid promotion --> promotion IS NOT NULL


WITH sales_data AS (
    SELECT product_family, 
           COALESCE(units_sold, 0) AS units_sold,
           CASE WHEN promotion_id IS NOT NULL THEN units_sold ELSE 0 END AS promotional_units_sold
    FROM   facebook_products fp LEFT JOIN facebook_sales fs USING(product_id)
),
combined_data AS (
    SELECT   product_family, 
             SUM(units_sold) AS total_units_sold,
             SUM(promotional_units_sold) AS total_promotional_units_sold
    FROM     sales_data
    GROUP BY 1
)
SELECT   product_family,
         COALESCE(total_units_sold, 0) AS total_units_sold,
         COALESCE(total_promotional_units_sold, 0) AS total_promotional_units_sold,
         COALESCE(total_promotional_units_sold * 100.0 / NULLIF(total_units_sold, 0), 0) AS percentage_promotional_units_sold
FROM     combined_data
ORDER BY 1