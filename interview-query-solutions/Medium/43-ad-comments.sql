-- Solution 1: using separate CTE's for feed and moments and then joining them in the end

WITH feeds_cte as (
    SELECT   ads.id as ad_id, COUNT(DISTINCT comment_id) as num_comments
    FROM     ads LEFT JOIN feed_comments fc ON ads.id = fc.ad_id
    GROUP BY ads.id
)
,moments_cte as(
    SELECT   ads.id as ad_id, COUNT(DISTINCT comment_id) as num_comments
    FROM     ads LEFT JOIN moments_comments mc ON ads.id = mc.ad_id
    GROUP BY ads.id
)
SELECT ads.name,
       1.0 * fc.num_comments / (fc.num_comments + mc.num_comments) as percentage_feed,
       1.0 * mc.num_comments / (fc.num_comments + mc.num_comments) as percentage_moments
FROM   ads LEFT JOIN feeds_cte fc ON ads.id = fc.ad_id
           LEFT JOIN moments_cte mc ON ads.id = mc.ad_id




-- Solution 2: using UNION ALL to get all comments

WITH total_comments AS (
    SELECT ad_id, comment_id, 'feed' as type
    FROM   feed_comments
    UNION
    SELECT ad_id, comment_id, 'moment' as type
    FROM   moments_comments
)
SELECT   ads.name,
         1.0 * SUM(CASE WHEN t.type = 'feed' THEN 1 ELSE 0 END) / COUNT(*) as percentage_feed,
         1.0 * SUM(CASE WHEN t.type = 'moment' THEN 1 ELSE 0 END) / COUNT(*) as percentage_moments
FROM     total_comments t LEFT JOIN ads ON t.ad_id = ads.id
GROUP BY ads.name




-- Solution 3: using just DISTINCT

SELECT   name, 
         1.0 * COUNT(DISTINCT f.user_id) / (COUNT(DISTINCT f.user_id) + COUNT(DISTINCT m.user_id)) as percentage_feed, 
         1.0 * COUNT(DISTINCT m.user_id) / (COUNT(DISTINCT f.user_id) + COUNT(DISTINCT m.user_id)) as percentage_moments
FROM     ads a LEFT JOIN feed_comments f ON a.id = f.ad_id
               LEFT JOIN moments_comments m ON a.id = m.ad_id
GROUP BY name