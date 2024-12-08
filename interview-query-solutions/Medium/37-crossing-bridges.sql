-- 2. Write a query on the given tables to get the time of the fastest car on the current day.

SELECT   license_plate,
         MIN(EXTRACT(EPOCH FROM exit_time - enter_time)) as crossing_time
FROM     crossings
WHERE    DATE(enter_time) = CURRENT_DATE and DATE(exit_time) = CURRENT_DATE
GROUP BY license_plate
ORDER BY crossing_time
LIMIT    1



-- 3. Write a query on the given tables to get the car model with the average fastest times for the current day.

SELECT   model_name,
         SUM(EXTRACT(EPOCH FROM exit_time - enter_time)) / COUNT(*) as avg_crossing_time
FROM     crossing as c JOIN car_models as cm ON c.car_model_id = cm.id
GROUP BY model_name
ORDER BY avg_crossing_time
LIMIT    1