WITH get_dates as (
    SELECT   traveler, MIN(date) as first_date, MAX(date) as last_date
    FROM     travel_history
    GROUP BY traveler
),
get_start_city as (
    SELECT th.traveler, start_city
    FROM   travel_history th JOIN get_dates d ON th.traveler=d.traveler and th.date=d.first_date
),
get_end_city as (
    SELECT th.traveler, end_city
    FROM   travel_history th JOIN get_dates d ON th.traveler=d.traveler and th.date=d.last_date
)
SELECT COUNT(*) as n_travelers_returned
FROM   get_start_city sc JOIN get_end_city ec ON sc.traveler=ec.traveler
WHERE  start_city=end_city




-- NOTE: 