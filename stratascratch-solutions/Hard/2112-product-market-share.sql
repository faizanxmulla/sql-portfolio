WITH quarterly_sold_products AS (
    SELECT   territory_id, 
             prod_brand,
             COUNT(fct.prod_sku_id) AS products_sold
    FROM     map_customer_territory mct LEFT JOIN fct_customer_sales fct USING(cust_id)
                                        LEFT JOIN dim_product dp USING(prod_sku_id)
    WHERE    EXTRACT(QUARTER FROM fct.order_date) = 4 AND 
             EXTRACT(YEAR FROM fct.order_date) = 2021
    GROUP BY 1, 2
    HAVING   COUNT(fct.prod_sku_id) > 0
),
total_sales_per_territory AS (
    SELECT   territory_id,
             SUM(products_sold) AS total_sales
    FROM     quarterly_sold_products
    GROUP BY 1
)
SELECT   territory_id,
         prod_brand,
         100.0 * (products_sold / total_sales) AS market_share
FROM     quarterly_sold_products qsp JOIN total_sales_per_territory tsp USING(territory_id)
ORDER BY 1, 2




-- my initial attempt: 

-- mistakes include: 
-- 1. LEFT join
-- 2. 


WITH quarterly_sold_products AS (
    SELECT   territory_id, 
             CONCAT('Q', EXTRACT(QUARTER FROM order_date), '-', EXTRACT(YEAR FROM order_date)) AS quarter_year,
             prod_brand,
             COUNT(prod_sku_id) AS products_sold
    FROM     map_customer_territory mct JOIN fct_customer_sales fct USING(cust_id)
                                        JOIN dim_product dp USING(prod_sku_id)
    GROUP BY 1, 2, 3
),
market_share_revenue AS (
    SELECT   territory_id,
             prod_brand,
             SUM(products_sold) AS total_sales,
             SUM(products_sold) FILTER(WHERE quarter_year='Q4-2021') AS required_quarter_sales
    FROM     quarterly_sold_products
    GROUP BY 1, 2
)
SELECT   territory_id,
         prod_brand,
         100.0 * (required_quarter_sales / total_sales) AS market_share
FROM     market_share_revenue
WHERE    required_quarter_sales > 0
ORDER BY 1, 2