WITH sales_cte as (
    SELECT *, 
           LAG(sales_volume) OVER(PARTITION BY product_id ORDER BY date) as prev_day_sales,
           LAG(sales_volume, 2) OVER(PARTITION BY product_id ORDER BY date) as prev_2_day_sales
    FROM   sales
)
SELECT   date, 
         product_id,
         (sales_volume*0.5 + prev_day_sales*0.3 + prev_2_day_sales*0.2) as weighted_avg_sales
FROM     sales_cte
WHERE    prev_day_sales IS NOT NULL and prev_2_day_sales IS NOT NULL
GROUP BY 1, 2



-- NOTE: solved in first attempt