WITH combined_wines_corpus as (
    SELECT distinct region_1 as region, variety, price
    FROM   winemag_p1
    WHERE  region_1 IS NOT NULL and price IS NOT NULL
    UNION 
    SELECT distinct region_2, variety, price
    FROM   winemag_p1
    WHERE  region_2 IS NOT NULL and price IS NOT NULL
)
SELECT   region, variety, SUM(price) as total
FROM     combined_wines_corpus
GROUP BY region, variety
ORDER BY total desc