WITH ranked_cool_votes as (
    SELECT   business_name, 
             review_text, 
             RANK() OVER(ORDER BY SUM(cool) desc) as rn
    FROM     yelp_reviews
    GROUP BY business_name, review_text
)
SELECT business_name, review_text
FROM   ranked_cool_votes
WHERE  rn=1