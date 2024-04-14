SELECT tt1.order_date,
       tt1.product_type,
       (
        SELECT SUM(quantity)
        FROM   total_trans tt2
        WHERE  tt1.order_date >= tt2.order_date and 
               tt1.product_type = tt2.product_type
       ) x
FROM   total_trans tt1



-- another approach: dont know for sure if works or not.


SELECT DISTINCT order_date, 
                product_type, 
                SUM(CASE 
                        WHEN order_date >= LAG(order_date) 
                          OVER (PARTITION BY product_type ORDER BY order_date) 
                        THEN quantity ELSE 0 END) 
                    OVER (PARTITION BY order_date, product_type) AS x
FROM   total_trans


