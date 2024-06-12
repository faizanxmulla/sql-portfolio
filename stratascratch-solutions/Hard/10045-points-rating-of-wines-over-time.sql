-- my solution: 

WITH points_per_year AS (
    SELECT   (regexp_match(title,'(\d{4})'))[1]::NUMERIC as year,
             COALESCE(AVG(points), 87) AS avg_points
    FROM     winemag_p2
    GROUP BY 1
),
points_per_prev_year AS (
    SELECT *, LAG(avg_points) OVER(ORDER BY year) AS prev_avg_points
    FROM   points_per_year
    WHERE  year >= 2000
)
SELECT year,
       avg_points,
       COALESCE(prev_avg_points, 87) AS prev_avg_points,
       (avg_points - COALESCE(prev_avg_points, 87)) AS points_diff
FROM   points_per_prev_year



-- alternative solution (found on github - seems more correct than mine - gives the same answer as mine; but creates data for years having no data - which is the way it should be)

WITH t1 AS (
    SELECT title,
           (regexp_match(title, '(\d{4})'))[1]::NUMERIC AS year,
           points
    FROM   winemag_p2
),
t2 AS (
    SELECT   year, AVG(points) AS avg_points
    FROM     t1
    WHERE    year IS NOT NULL
    GROUP BY 1
),
t3 AS (
    SELECT generate_series(2000, (SELECT MAX(year) 
                                  FROM   t2)) AS year
) 
SELECT t3.year,
       COALESCE(t2a.avg_points, 87) AS avg_points,
       COALESCE(t2b.avg_points, 87) AS prev_avg_points,
       (COALESCE(t2a.avg_points, 87) - COALESCE(t2b.avg_points, 87)) AS points_diff
FROM   t3 LEFT JOIN t2 t2a ON t2a.year = t3.year
          LEFT JOIN t2 t2b ON t2b.year = t3.year - 1;
