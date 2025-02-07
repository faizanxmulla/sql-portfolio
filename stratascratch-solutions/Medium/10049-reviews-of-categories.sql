-- Solution 1: using UNNEST and STRING_TO_ARRAY

SELECT   UNNEST(STRING_TO_ARRAY(categories, ';')), SUM(review_count) as total_reviews
FROM     yelp_business
GROUP BY category
ORDER BY total_reviews desc



-- Solution 2: using STRING_TO_TABLE

SELECT   STRING_TO_TABLE(categories, ';'), SUM(review_count) as total_reviews
FROM     yelp_business
GROUP BY category
ORDER BY total_reviews desc