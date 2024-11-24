SELECT PERCENTILE_CONT(0.9) WITHIN GROUP(ORDER BY EXTRACT(MINUTE FROM AGE(actual_time_of_arrival, predicted_eta))) as ninetieth_percentile
FROM   trip_details
WHERE  status='completed'
       and actual_time_of_arrival BETWEEN '2022-01-01' AND '2022-01-14'