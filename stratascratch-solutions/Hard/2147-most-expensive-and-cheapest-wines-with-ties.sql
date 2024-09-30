WITH CTE as (
    SELECT region_1 as region, variety, price
    FROM   winemag_pd
    UNION ALL
    SELECT region_2 as region, variety, price
    FROM   winemag_pd
),
ranked_wines as (
    SELECT region,
           variety,
           RANK() OVER(PARTITION BY region ORDER BY price DESC) AS highest_rn,
           RANK() OVER(PARTITION BY region ORDER BY price) AS lowest_rn
    FROM   CTE
    WHERE  region IS NOT NULL and price IS NOT NULL
),
expensive_wines_cte as (
    SELECT DISTINCT region, variety as most_expensive_variety
    FROM   ranked_wines
    WHERE  highest_rn=1
),
cheapest_wines_cte as (
    SELECT DISTINCT region, variety as cheapest_variety
    FROM   ranked_wines
    WHERE  lowest_rn=1
)
SELECT   e.region as region,
         most_expensive_variety,
         cheapest_variety
FROM     expensive_wines_cte e JOIN cheapest_wines_cte c USING(region)
ORDER BY 1 DESC



-- NOTE: 

-- exactly similar to #10041; only difference is this question has ties.

-- can't use MAX(CASE WHEN ...) or MAX() FILTER(WHERE ...); instead have to create two separate CTE's and then join them later.

-- minute detail: both table names are different - 'winemag_pd v/s winemag_p1'
