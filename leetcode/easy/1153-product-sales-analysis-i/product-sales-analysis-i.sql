SELECT p.product_name, s.year , s.price 
FROM Sales s
LEFT JOIN Product p
# USING (product_id)
ON s.product_id = p.product_id 


# alternate solution : 

# SELECT DISTINCT P.product_name, S.year, S.price 
# FROM 
#     (SELECT DISTINCT product_id, year, price 
#     FROM Sales
#     ) S
# INNER JOIN Product AS P
# USING (product_id);
