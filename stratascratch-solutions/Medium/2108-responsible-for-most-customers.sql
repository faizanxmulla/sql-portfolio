WITH ranked_customers as (
    SELECT   empl_id, 
             COUNT(cust_id) as n_customers,
             RANK() OVER(ORDER BY COUNT(cust_id) desc) as rn
    FROM     map_employee_territory et JOIN map_customer_territory ct ON et.territory_id=ct.territory_id
    GROUP BY empl_id
)
SELECT empl_id, n_customers
FROM   ranked_customers
WHERE  rn=1



-- NOTE: solved on first attempt