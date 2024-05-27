WITH first_year_cte AS (
    SELECT   product_id, MIN(year) AS first_year
    FROM     Sales
    GROUP BY 1
)
SELECT s.product_id, first_year, quantity, price
FROM   Sales s JOIN first_year_cte f ON s.product_id = f.product_id AND 
                                        s.year = f.first_year;



-- my initial attempt: (failing because returns all rows of the first year)

-- SELECT   product_id, 
--          MIN(year) OVER(PARTITION BY product_id) AS first_year, 
--          quantity, 
--          price
-- FROM     Sales
-- ORDER BY 1
