WITH algorithm_cte AS (
    SELECT  search_id,
            (CASE WHEN clicked = 0 THEN 1
                  WHEN clicked = 1 and search_results_position > 3 THEN 2
                  WHEN clicked = 1 and search_results_position <= 3 THEN 3
            END) AS rating
    FROM    fb_search_events)
SELECT   search_id,
         MAX(rating) AS max_rating
FROM     algorithm_cte
GROUP BY 1
ORDER BY 1