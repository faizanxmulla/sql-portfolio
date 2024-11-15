WITH ranked_cities as (
    SELECT   city, 
             COUNT(o.order_id) as rides_count,
             RANK() OVER(ORDER BY COUNT(o.order_id) desc) as rn
    FROM     lyft_orders o JOIN lyft_payments p ON o.order_id=p.order_id
    WHERE    order_date BETWEEN '2021-08-01' and '2021-08-31' 
             and promo_code='FALSE'
    GROUP BY 1
)
SELECT city
FROM   ranked_cities 
WHERE  rn=1



-- NOTE: solved on first attempt