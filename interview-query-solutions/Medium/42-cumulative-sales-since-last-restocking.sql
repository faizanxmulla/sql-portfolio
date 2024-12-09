WITH last_restock AS (
    SELECT   product_id, MAX(restock_date) as restock_date
    FROM     restocking
    GROUP BY product_id
) 
SELECT   p.product_name,
         s.date,
         SUM(s.sold_count) OVER(PARTITION BY p.product_id, lr.restock_date
                                ORDER BY s.date) as sales_since_last_restock
FROM     sales s JOIN products p ON p.product_id = s.product_id
                 JOIN last_restock lr ON p.product_id = lr.product_id
WHERE    s.date >= lr.restock_date
ORDER BY p.product_id



-- NOTE: got the basic idea correct; couldn't properly figure out the restocking part.