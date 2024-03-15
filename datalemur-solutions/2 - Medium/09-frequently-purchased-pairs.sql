WITH CTE as (
    SELECT *
    FROM   transactions t JOIN products p USING(product_id)
)
SELECT   a.product_name as product1, 
         b.product_name as product2,
         COUNT(*) as comb_num
FROM     CTE a JOIN CTE b 
         ON a.transaction_id = b.transaction_id 
         AND a.product_id > b.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT    3



