WITH host_id_cte AS (
    SELECT DISTINCT CONCAT(price, room_type, host_since, zipcode, number_of_reviews) AS host_id,
          number_of_reviews,
          price
   FROM   airbnb_host_searches
),
review_categories AS (
    SELECT   *, 
             CASE 
                 WHEN number_of_reviews = 0 THEN 'New'
                 WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'Rising'
                 WHEN number_of_reviews BETWEEN 6 AND 15 THEN 'Trending Up'
                 WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
                 ELSE 'Hot'
             END AS host_pop_rating
    FROM     host_id_cte
)
SELECT   host_pop_rating,
         MIN(price) AS min_price, 
         AVG(price) AS avg_price,
         MAX(price) AS max_price
FROM     review_categories
GROUP BY 1