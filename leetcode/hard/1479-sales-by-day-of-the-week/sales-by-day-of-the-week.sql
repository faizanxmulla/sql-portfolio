-- Solution: 

WITH sales_by_day AS (
    SELECT   item_category,
             EXTRACT(DOW FROM order_date) AS day_of_week,
             SUM(quantity) AS total_quantity
    FROM     items i LEFT JOIN orders o USING(item_id)
    GROUP BY 1, 2
)
SELECT   item_category AS Category,
         COALESCE(SUM(CASE WHEN day_of_week = 1 THEN total_quantity END), 0) AS Monday,
         COALESCE(SUM(CASE WHEN day_of_week = 2 THEN total_quantity END), 0) AS Tuesday,
         COALESCE(SUM(CASE WHEN day_of_week = 3 THEN total_quantity END), 0) AS Wednesday,
         COALESCE(SUM(CASE WHEN day_of_week = 4 THEN total_quantity END), 0) AS Thursday,
         COALESCE(SUM(CASE WHEN day_of_week = 5 THEN total_quantity END), 0) AS Friday,
         COALESCE(SUM(CASE WHEN day_of_week = 6 THEN total_quantity END), 0) AS Saturday,
         COALESCE(SUM(CASE WHEN day_of_week = 0 THEN total_quantity END), 0) AS Sunday
FROM     sales_by_day
GROUP BY 1
ORDER BY 1


-- my initial approach: (w/o seeing the result set)

SELECT   EXTRACT(DOW FROM order_date) AS day_of_week, 
         item_category, 
         SUM(quantity) AS total_quantity
FROM     orders o JOIN items i USING(item_id)
GROUP BY 1, 2
ORDER BY 1, 2