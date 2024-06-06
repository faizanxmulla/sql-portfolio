WITH quarterly_revenue AS (
    SELECT   territory_id,
             CONCAT('Q', EXTRACT(QUARTER FROM order_date), '-', EXTRACT(YEAR FROM order_date)) AS quarter_year,
             SUM(order_value) AS total_revenue
    FROM     fct_customer_sales fct JOIN map_customer_territory mct USING(cust_id)
    GROUP BY 1, 2
),
filtered_quarterly_revenue AS (
    SELECT   territory_id, 
             SUM(total_revenue) FILTER(WHERE quarter_year='Q4-2021') AS q4_2021,
             SUM(total_revenue) FILTER(WHERE quarter_year='Q3-2021') AS q3_2021
    FROM     quarterly_revenue
    GROUP BY 1
)
SELECT   territory_id, 
         ((q4_2021 - q3_2021) / q3_2021) * 100 AS sales_growth
FROM     filtered_quarterly_revenue
WHERE    q4_2021 IS NOT NULL AND q3_2021 IS NOT NULL
ORDER BY 1
