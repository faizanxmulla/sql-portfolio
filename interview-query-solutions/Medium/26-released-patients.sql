WITH prev_cte as (
    SELECT release_date, 
           released_patients,
           LAG(released_patients) OVER(ORDER BY release_date) as prev_release_patients
    FROM   released_patients
)
SELECT release_date, released_patients
FROM   prev_cte
WHERE  released_patients > prev_release_patients