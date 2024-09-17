![image](https://github.com/user-attachments/assets/997729d2-4f62-4929-8532-6bd4deeb5914)


### Solution Query

```sql
-- Solution 1: using ROW_NUMBER and CTE: 

WITH latest_prices AS (
    SELECT o.order_id,
           o.product_id,
           o.order_date,
           p.price,
           ROW_NUMBER() OVER(PARTITION BY o.order_id ORDER BY p.price_date DESC) AS rn
    FROM   orders o JOIN products p ON o.product_id = p.product_id AND p.price_date <= o.order_date
)
SELECT   lp.product_id, SUM(lp.price) AS total_sales
FROM     latest_prices lp
WHERE    rn = 1
GROUP BY 1
ORDER BY 1


-- Solution 2: using MAX and subquery

SELECT   o.product_id, SUM(p.price) AS total_sales
FROM     orders o JOIN products p USING(product_id) 
                  AND p.price_date = (
                          SELECT MAX(price_date)
                          FROM   products
                          WHERE  product_id = o.product_id AND price_date <= o.order_date
                    )
GROUP BY 1
ORDER BY 1
```