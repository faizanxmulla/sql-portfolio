WITH CTE AS (
    SELECT name, 
           rating,
           AVG(COALESCE(rating, 0)) OVER(PARTITION BY name) AS avg_lifetime_rating,
           RANK() OVER(PARTITION BY name ORDER BY id DESC) AS rn
    FROM   nominee_filmography
    WHERE  role_type='Normal Acting' AND rating IS NOT NULL
)
SELECT name, 
       avg_lifetime_rating, 
       rating,
       ABS(avg_lifetime_rating - rating) AS abs_rating_diff
FROM   CTE
WHERE  rn=2
       
