WITH dec_2019_ranked AS (
    SELECT   u.country,
             COUNT(*) AS no_comments,
             DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS dr
    FROM     fb_comments_count c JOIN fb_active_users u USING(user_id)
    WHERE    TO_CHAR(created_at, 'YYYY-MM') = '2019-12'
    GROUP BY 1
),
jan_2020_ranked AS (
    SELECT   u.country,
             COUNT(*) AS no_comments,
             DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS dr
    FROM     fb_comments_count c JOIN fb_active_users u USING(user_id)
    WHERE    TO_CHAR(created_at, 'YYYY-MM') = '2020-01'
    GROUP BY 1
)
SELECT j.country
FROM   dec_2019_ranked d RIGHT JOIN jan_2020_ranked j USING(country)
WHERE  (j.dr < d.dr) OR d.dr IS NULL