WITH reviewed_flags_cte AS (
    SELECT   video_id, 
             COUNT(flag_id) AS all_flags,
             COUNT(flag_id) FILTER(WHERE reviewed_by_yt='TRUE') AS reviewed_flags
    FROM     user_flags uf JOIN flag_review fr USING(flag_id)
    GROUP BY 1
)
SELECT video_id, reviewed_flags
FROM   reviewed_flags_cte
WHERE  all_flags IN (
        SELECT MAX(all_flags)
        FROM   reviewed_flags_cte
        )