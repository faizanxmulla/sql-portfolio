WITH all_months AS (
    SELECT generate_series(1, 12) AS month_number

), 
active_drivers_per_month AS (
    SELECT   EXTRACT(MONTH FROM d.join_date) AS month,
             COUNT(d.driver_id) AS active_drivers
    FROM     drivers d
    WHERE    EXTRACT(YEAR FROM d.join_date) = 2020
    GROUP BY 1
),
accepted_rides_per_month AS (
    SELECT   EXTRACT(MONTH FROM r.requested_at) AS month,
             COUNT(ar.ride_id) AS accepted_rides
    FROM     rides r JOIN acceptedrides ar USING(ride_id)
    WHERE    EXTRACT(YEAR FROM r.requested_at) = 2020
    GROUP BY 1
)
SELECT   m.month_number AS month,
         COALESCE(ad.active_drivers, 0) AS active_drivers,
         COALESCE(ar.accepted_rides, 0) AS accepted_rides
FROM     all_months m LEFT JOIN active_drivers_per_month ad ON m.month_number = ad.month
				      LEFT JOIN accepted_rides_per_month ar ON m.month_number = ar.month
ORDER BY 1


-- NOTE: exactly similar to #1635 (Hooper Company Analysis - I)