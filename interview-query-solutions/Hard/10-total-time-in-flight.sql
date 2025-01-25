WITH preprocessed_flights as (
    SELECT plane_id,
           flight_start,
           flight_end,
           DATE(flight_start) as start_date,
           DATE(flight_end) as end_date
    FROM   flights
)
, split_fights as (
    SELECT plane_id,
           start_date,
           end_date,
           CASE 
                WHEN start_date = end_date THEN TIMESTAMPDIFF(MINUTE, flight_start, flight_end)
                ELSE TIMESTAMPDIFF(MINUTE, flight_start, start_date + INTERVAL 1 DAY)
           END as time_on_start_date,
           CASE 
                WHEN start_date = end_date THEN 0
                ELSE TIMESTAMPDIFF(MINUTE, end_date, flight_end)
           END as time_on_end_date
    FROM   preprocessed_flights
)
, flight_times as (
    SELECT plane_id,
           start_date as calendar_day,
           time_on_start_date as time_in_min
    FROM   split_fights
    UNION ALL
    SELECT plane_id,
           end_date as calendar_day,
           time_on_end_date as time_in_min
    FROM   split_fights
    WHERE  time_on_end_date > 0
)
SELECT   plane_id,
         DATE_FORMAT(calendar_day, '%Y-%m-%d') as calendar_day,
         FLOOR(SUM(time_in_min)) as time_in_min
FROM     flight_times
GROUP BY plane_id, calendar_day
ORDER BY plane_id



-- my attempt: 

SELECT   TO_CHAR(flight_start, 'YYYY-MM-DD') as calendar_day,
         plane_id,       
         ROUND(SUM(EXTRACT(EPOCH FROM (flight_end - flight_start)) / 60)) as time_in_min
FROM     flights
GROUP BY calendar_day, plane_id
ORDER BY plane_id


-- NOTE: 

-- didnt take into account the fact that flight start and end can be on different days.

-- for postgres:
-- 1. replace TIMESTAMPDIFF(MINUTE, ...) w/ EXTRACT(EPOCH FROM (...)) / 60
-- 2. replace TO_CHAR(calendar_day, 'YYYY-MM-DD') w/ DATE_FORMAT(calendar_day, '%Y-%m-%d')

