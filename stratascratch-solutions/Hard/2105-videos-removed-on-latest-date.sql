WITH a AS (
    SELECT   user_firstname,
             user_lastname,
             MAX(fr.reviewed_date) AS max_reviewed_date
    FROM     user_flags uf JOIN flag_review fr USING(flag_id)
    WHERE    fr.reviewed_by_yt = TRUE 
    GROUP BY 1, 2
),
b AS (
    SELECT   fr.reviewed_date,
             COUNT(DISTINCT uf.video_id) AS video_count
    FROM     user_flags uf JOIN flag_review fr USING(flag_id)
    WHERE    fr.reviewed_by_yt = TRUE AND fr.reviewed_outcome = 'REMOVED'
    GROUP BY 1
)
SELECT a.user_firstname, a.user_lastname, a.max_reviewed_date, COALESCE(b.video_count, 0) AS video_count
FROM   a LEFT JOIN b ON a.max_reviewed_date = b.reviewed_date