WITH CTE as (
    SELECT region_1 as region, variety, price
    FROM   winemag_p1
    UNION ALL
    SELECT region_2 as region, variety, price
    FROM   winemag_p1
),
ranked_wines as (
    SELECT region,
           variety,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY price DESC) AS highest_rn,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY price) AS lowest_rn
    FROM   CTE
    WHERE  region IS NOT NULL and price IS NOT NULL
)
SELECT   region,
         MAX(CASE WHEN highest_rn=1 THEN variety ELSE NULL END) as most_expensive_variety,
         MAX(CASE WHEN lowest_rn=1 THEN variety ELSE NULL END) as cheapest_variety
FROM     ranked_wines
GROUP BY 1



-- NOTE: 

-- exactly similar to #2147; only difference is this question doesn't have ties.

-- can use MAX(CASE WHEN ...) or MAX() FILTER(WHERE ...) as no ties.

-- minute detail: both table names are different - 'winemag_p1 v/s winemag_pd'