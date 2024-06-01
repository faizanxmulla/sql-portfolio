WITH region_variety AS (
    SELECT region_1 AS region,
           variety,
           price
    FROM   winemag_p1
    WHERE  price IS NOT NULL AND region_1 IS NOT NULL
    UNION ALL 
    SELECT region_2 AS region,
           variety,
           price
    FROM   winemag_p1
    WHERE  price IS NOT NULL AND region_2 IS NOT NULL
), 
rank_variety_price AS (
    SELECT region,
           variety,
           DENSE_RANK() OVER(PARTITION BY region ORDER BY price DESC) AS expensive_rk,
           DENSE_RANK() OVER(PARTITION BY region ORDER BY price) AS cheap_rk
    FROM   region_variety
)
SELECT   region,
         MAX(variety) FILTER (WHERE expensive_rk = 1) AS expensive_variety,
         MAX(variety) FILTER (WHERE cheap_rk = 1) AS cheap_variety
FROM     rank_variety_price 
GROUP BY 1
