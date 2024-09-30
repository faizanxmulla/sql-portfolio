SELECT   se.city_id,
         DATE(timestamp) as date,
         100.0 * COUNT(DISTINCT se.rider_id) / COUNT(DISTINCT driver_id) as percentage
FROM     signup_events se LEFT JOIN trip_details td 
ON       se.rider_id=td.driver_id 
         and EXTRACT(EPOCH FROM (se.timestamp - td.actual_time_of_arrival)) / 3600 < 168
WHERE    event_name='su_success'
         and status='completed'
         and DATE(timestamp) BETWEEN '2022-01-01' AND '2022-01-07'
GROUP BY 1, 2
ORDER BY 1, 2



-- NOTE: tried using COUNT() FILTER(WHERE ...) and complicated it a bit too much.