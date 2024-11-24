WITH ranked_videos_per_users as (
    SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY watched_at) as video_rank
    FROM   videos_watched
)
,top_3_videos as (
SELECT   video_id, 
         COUNT(*) as n_in_first_3, 
         DENSE_RANK() OVER(ORDER BY COUNT(*) desc) as dr
FROM     ranked_videos_per_users
WHERE    video_rank <= 3
GROUP BY video_id
)
SELECT video_id, n_in_first_3
FROM   top_3_videos
WHERE  dr <= 3



-- NOTE: solved on first attempt