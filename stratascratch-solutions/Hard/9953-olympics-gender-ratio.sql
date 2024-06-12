WITH user_genders AS (
    SELECT   games,
             SUM(CASE WHEN sex='M' THEN 1 ELSE 0 END) AS male_users,
             SUM(CASE WHEN sex='F' THEN 1 ELSE 0 END) AS female_users
    FROM     olympics_athletes_events
    GROUP BY 1
    ORDER BY 1
)
SELECT *, 1.0 * male_users / NULLIF(female_users, 0) AS gender_ratio
FROM   user_genders