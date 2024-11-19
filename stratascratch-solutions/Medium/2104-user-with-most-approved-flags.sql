WITH ranked_videos as (
    SELECT   CONCAT(user_firstname, ' ', user_lastname) as username,
             RANK() OVER(ORDER BY COUNT(DISTINCT video_id) desc) as rn
    FROM     user_flags uf JOIN flag_review fr ON uf.flag_id=fr.flag_id
    WHERE    reviewed_outcome='APPROVED'
    GROUP BY 1
)
SELECT username
FROM   ranked_videos
WHERE  rn=1



-- NOTE: solved on first attempt