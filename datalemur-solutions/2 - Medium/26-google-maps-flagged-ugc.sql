-- As a Data Analyst on the Google Maps User Generated Content team, you and your Product Manager are investigating user-generated content (UGC) – photos and reviews that independent users upload to Google Maps.

-- Write a query to determine which type of place (place_category) attracts the most UGC tagged as "off-topic". In the case of a tie, show the output in ascending order of place_category.

-- place_info 

-- Example Input:
-- place_id	place_name	place_category
-- 1	Baar Baar	Restaurant
-- 2	Rubirosa	Restaurant
-- 3	Mr. Purple	Bar
-- 4	La Caverna	Bar

-- maps_ugc_review 

-- Example Input:
-- content_id	place_id	content_tag
-- 101	1	Off-topic
-- 110	2	Misinformation
-- 153	2	Off-topic
-- 176	3	Harassment
-- 190	3	Off-topic



WITH cte AS (
    SELECT   place.place_category,
             COUNT(ugc.content_id) AS content_count
    FROM     place_info place JOIN maps_ugc_review ugc ON USING(place_id)
    WHERE    content_tag = 'Off-topic'
    GROUP BY 1
)
SELECT place_category,
       content_count,
       RANK() OVER (ORDER BY content_count MYSTERY_KEYWORD) AS top_place
FROM   cte


-- remarks: found this premium question here : https://datalemur.com/blog/google-sql-interview-questions

