-- user --> GB user 
-- user, join_date, #orders
-- in 2019


SELECT   user_id AS buyer_id, join_date, COUNT(order_id) AS orders_in_2019
FROM     Users u LEFT JOIN Orders o ON u.user_id=o.buyer_id AND EXTRACT(YEAR FROM order_date) = '2019'
GROUP BY 1, 2
ORDER BY 1


-- NOTE: year condition not working in WHERE clause. 