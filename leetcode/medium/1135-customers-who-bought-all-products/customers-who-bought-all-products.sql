SELECT   c.customer_id
FROM     Customer c JOIN Product p USING(product_key)
GROUP BY 1
HAVING   COUNT(DISTINCT c.product_key) = (SELECT COUNT(*) FROM Product)



-- my approach: 

-- SELECT   customer_id, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY product_key)
-- FROM     Customer c JOIN Product p USING(product_key)
-- GROUP BY 1

-- COUNT(distinct p.product_key)


-- remarks : unnecessarily complicated it.