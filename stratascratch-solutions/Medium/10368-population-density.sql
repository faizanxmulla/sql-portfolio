WITH ranked_cities as (
    SELECT city, 
           country, 
           ROUND(population/area) as density,
           RANK() OVER(ORDER BY population/area) as min_rn,
           RANK() OVER(ORDER BY population/area desc) as max_rn
    FROM   cities_population
    WHERE  area > 0
)
SELECT city, country, density
FROM   ranked_cities
WHERE  min_rn=1 or max_rn=1



-- NOTE: solved on first attempt