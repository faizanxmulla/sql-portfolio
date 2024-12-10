WITH ranked_points as (
    SELECT student_id, 
           hrs_studied, 
           sat_math,
           1.0 * sat_math / hrs_studied as points_per_hour,
           RANK() OVER(ORDER BY sat_math / hrs_studied desc) as rn
    FROM   sat_scores
    WHERE  hrs_studied >= 1
)
SELECT student_id, hrs_studied, sat_math, points_per_hour
FROM   ranked_points
WHERE  rn=1



-- NOTE: solved on first attempt