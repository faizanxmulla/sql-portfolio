SELECT   UNNEST(STRING_TO_ARRAY(REPLACE(REPLACE(post_keywords, '[', ''), ']', ''), ',')) AS post_keywords, 
         COUNT(viewer_id) AS viewers_count
FROM     facebook_posts fp LEFT JOIN facebook_post_views pv USING(post_id)
GROUP BY 1
ORDER BY 2 DESC