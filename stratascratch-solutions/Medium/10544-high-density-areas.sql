WITH ranked_densities as (
    SELECT   s.area_name, 
             COUNT(distinct tr.customer_id) / s.area_size::float as customer_density,
             RANK() OVER(ORDER BY COUNT(distinct tr.customer_id) / s.area_size::float desc) as rn
    FROM     transaction_records tr JOIN stores s ON tr.store_id=s.store_id
    GROUP BY s.area_name, s.area_size
)
SELECT area_name, customer_density
FROM   ranked_densities 
WHERE  rn <= 3