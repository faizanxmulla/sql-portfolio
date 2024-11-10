WITH city_customers_count as (
    SELECT   co.country_name, 
             ci.city_name, 
             COUNT(cu.id) as total_customers
    FROM     linkedin_customers cu JOIN linkedin_city ci ON cu.city_id=ci.id
                                   JOIN linkedin_country co ON ci.country_id=co.id
    GROUP BY 1, 2
),
avg_customers_count as (
    SELECT COUNT(id)::float / COUNT(DISTINCT city_id) as avg_customers
    FROM   linkedin_customers
)
SELECT country_name,
       city_name,
       total_customers
FROM   city_customers_count
WHERE  total_customers > (SELECT avg_customers FROM avg_customers_count)




-- NOTE: 

-- was trying this initially: -- AVG(cu.id) OVER(PARTITION BY ci.id) as avg_customers
-- and solution in only 2 CTE's, but couldn't do it.