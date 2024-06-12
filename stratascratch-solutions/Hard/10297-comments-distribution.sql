-- joined between 2018 and 2020
-- where month = jan 2020
-- output : #comments, #corr. users
-- OB #comments desc
-- where user_joining_date > user_post_date


WITH distribution_of_comments AS (
    SELECT   user_id, COUNT(created_at) AS comments_count
    FROM     fb_comments c JOIN fb_users u ON c.user_id=u.id
    WHERE    TO_CHAR(created_at, 'YYYY-MM') = '2020-01' AND 
             EXTRACT(YEAR FROM joined_at) BETWEEN 2018 AND 2020 AND
             joined_at <= created_at
    GROUP BY 1
    ORDER BY 2 DESC
)
SELECT   comments_count, COUNT(user_id) AS corresponding_users
FROM     distribution_of_comments
GROUP BY 1