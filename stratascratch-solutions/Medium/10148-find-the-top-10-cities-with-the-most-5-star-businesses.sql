WITH ranked_cities as (
    SELECT   city,
             COUNT(*) FILTER(WHERE stars=5) as count_of_5_stars,
             RANK() OVER(ORDER BY COUNT(*) FILTER(WHERE stars=5) desc) as rn
    FROM     yelp_business
    GROUP BY city
)
SELECT city, count_of_5_stars
FROM   ranked_cities
WHERE  rn <= 5