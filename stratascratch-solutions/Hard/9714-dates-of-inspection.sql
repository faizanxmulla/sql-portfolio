WITH max_score_inspections as (
    SELECT facility_name,
           score, 
           activity_date
    FROM   los_angeles_restaurant_health_inspections
    WHERE  facility_name LIKE '%RESTAURANT%' 
           and score = (
                SELECT MAX(score)
                FROM   los_angeles_restaurant_health_inspections
           )
),
inspection_intervals as (
    SELECT facility_name,
           score, 
           activity_date,
           LAG(activity_date) OVER(PARTITION BY facility_name ORDER BY activity_date) as prev_activity_date,
           RANK() OVER(PARTITION BY facility_name ORDER BY activity_date DESC) as rank
    FROM   max_score_inspections
)
SELECT facility_name,
       score, 
       activity_date,
       prev_activity_date,
       activity_date - prev_activity_date as number_of_days_between_high_scoring_inspections
FROM   inspection_intervals          
WHERE  rank=1