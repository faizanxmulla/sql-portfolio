SELECT   name, SUM(review_count) as total_reviews
FROM     yelp_business
GROUP BY name
ORDER BY total_reviews desc
LIMIT    5