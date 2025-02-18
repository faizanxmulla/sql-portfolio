SELECT   p.post_date, 
         100.00 * SUM(CASE WHEN p.post_keywords ILIKE '%spam%' THEN 1 ELSE 0 END)::float / 
                  COUNT(p.post_id) as spam_percentage 
FROM     facebook_post_views pv LEFT JOIN facebook_posts p ON pv.post_id=p.post_id
GROUP BY p.post_date