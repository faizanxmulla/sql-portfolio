SELECT   region,
         SUM(sale_amount) AS total_sales,
         SUM(CASE WHEN sale_date BETWEEN '2023-07-01' AND '2023-07-31' THEN sale_amount ELSE 0 END) AS promotional_sales,
         SUM(CASE WHEN (sale_amount >= 2000 OR region = 'East') AND NOT (sale_date BETWEEN '2023-07-01' AND '2023-07-31') THEN sale_amount ELSE 0 END) AS premium_sales,
         SUM(CASE WHEN sale_amount < 2000 AND region <> 'East' AND NOT (sale_date BETWEEN '2023-07-01' AND '2023-07-31') THEN sale_amount ELSE 0 END) AS standard_sales
FROM     sales
GROUP BY region



-- NOTE: solved on first attempt; had to pay attention on OR and AND in the conditions.