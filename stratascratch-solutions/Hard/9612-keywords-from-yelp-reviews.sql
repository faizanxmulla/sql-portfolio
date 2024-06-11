WITH reviews_cte AS (
    SELECT business_name
    FROM   yelp_reviews
    WHERE  review_text ~* '(food|pizza|sandwich|burger)'
)
SELECT rc.business_name AS name, 
       b.address AS address, 
       b.state
FROM   reviews_cte rc LEFT JOIN yelp_business b ON b.name=rc.business_name