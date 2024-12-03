WITH ranked_views as (
    SELECT   video_id, 
             DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT user_id)) as rn
    FROM     videos_watched
    GROUP BY video_id
)
SELECT video_id
FROM   ranked_views
WHERE  rn=1



-- NOTE: solved on first attempt