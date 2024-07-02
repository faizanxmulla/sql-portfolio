WITH all_months AS (
    SELECT generate_series(1, 12) AS month_number
), 
available_drivers_cte AS (
    SELECT   m.month_number,
             COUNT(d.driver_id) AS available_drivers
    FROM     all_months m LEFT JOIN drivers d
    ON       EXTRACT(YEAR FROM d.join_date) < 2020 OR 
             (EXTRACT(YEAR FROM d.join_date) = 2020 AND 
              EXTRACT(MONTH FROM d.join_date) <= m.month_number)
    WHERE    EXTRACT(YEAR FROM d.join_date) <= 2020
    GROUP BY 1
),
working_drivers_cte AS (
    SELECT   EXTRACT(MONTH FROM r.requested_at) AS month, 
             COUNT(DISTINCT ar.driver_id) AS working_drivers
    FROM     rides r JOIN acceptedrides ar USING(ride_id)
    WHERE    EXTRACT(YEAR FROM r.requested_at) = 2020
    GROUP BY 1

)
SELECT   m.month_number AS month, 
         ROUND(COALESCE(100.0 * (wd.working_drivers::NUMERIC / ad.available_drivers), 0), 2) AS working_percentage
FROM     all_months m LEFT JOIN available_drivers_cte ad ON m.month_number = ad.month_number
				      LEFT JOIN working_drivers_cte wd ON m.month_number = wd.month
ORDER BY 1