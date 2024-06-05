WITH male_athletes_heights AS (
    SELECT   year, COALESCE(AVG(height), 172.73) AS avg_height
    FROM     olympics_athletes_events
    WHERE    sex='M' AND year BETWEEN 1896 AND 2016
    GROUP BY 1
),
prev_year_heights AS (
    SELECT *, LAG(avg_height) OVER(ORDER BY year) as prev_avg_height
    FROM   male_athletes_heights
)
SELECT   year,
         avg_height,
         COALESCE(prev_avg_height, 172.73) AS avg_height,
         (avg_height - COALESCE(prev_avg_height, 172.73)) AS height_diff
FROM     prev_year_heights
ORDER BY 1