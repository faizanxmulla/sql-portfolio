WITH ranked_orders as (
    SELECT   o.city, 
             EXTRACT(MONTH FROM pd.order_date) as month,
             SUM(pd.order_fare) as profit,
             RANK() OVER(ORDER BY SUM(pd.order_fare) desc) as rn
    FROM     lyft_orders o JOIN lyft_payment_details pd ON o.order_id=pd.order_id
    WHERE    pd.order_date BETWEEN '2021-01-01' and '2021-12-31'
    GROUP BY 1, 2
)
SELECT city, month, profit
FROM   ranked_orders 
WHERE  rn=1