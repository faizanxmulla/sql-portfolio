WITH reviews_cte AS (
    SELECT   name, 
             opening_date, 
             COUNT(r.id) FILTER(WHERE score < 5) as negative_reviews,
             COUNT(r.id) FILTER(WHERE score >= 5) as positive_reviews, 
             COUNT(r.id) AS total_reviews
    FROM     instacart_stores s JOIN instacart_reviews r ON r.store_id=s.id
    WHERE    EXTRACT(YEAR FROM opening_date) = '2021' AND
             EXTRACT(QUARTER FROM opening_date) IN (3, 4)
    GROUP BY 1, 2
)
SELECT name, (negative_reviews::float / positive_reviews::float) AS reviews_ratio
FROM   reviews_cte
WHERE  (negative_reviews::float / total_reviews::float) > 0.20