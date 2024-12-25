SELECT   cust_id, SUM(total_order_cost) as total_revenue
FROM     orders
WHERE    order_date BETWEEN '2019-03-01' and '2019-03-31'
GROUP BY cust_id
ORDER BY total_revenue desc



-- NOTE: solved on first attempt