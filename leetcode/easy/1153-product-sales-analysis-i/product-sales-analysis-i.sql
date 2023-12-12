SELECT product_name, year , price 
FROM Sales
LEFT JOIN Product
USING (product_id)
# ON s.product_id = p.product_id 


# alternate solution : 

# SELECT DISTINCT P.product_name, S.year, S.price 
# FROM 
#     (SELECT DISTINCT product_id, year, price 
#     FROM Sales
#     ) S
# INNER JOIN Product AS P
# USING (product_id);
