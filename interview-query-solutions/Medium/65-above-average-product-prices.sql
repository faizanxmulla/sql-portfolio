WITH CTE AS (
    SELECT ROUND(AVG(price * quantity)::decimal, 2) as avg_price
    FROM   transactions t JOIN products p ON t.product_id = p.id
)
SELECT id as product_id, 
       price as product_price, 
       avg_price 
FROM   products JOIN CTE ON 1=1
WHERE  price > avg_price