WITH train_schedule AS (
    SELECT a.train_id, arrival_time, departure_time
    FROM   train_arrivals a JOIN train_departures d USING(train_id)
),
common_trains AS (
    SELECT t1.train_id, t2.train_id as concurrent_train
    FROM   train_schedule t1 JOIN train_schedule t2 
    ON     (t1.train_id != t2.train_id) AND NOT         
           ((t2.arrival_time < t1.arrival_time AND t2.departure_time < t1.arrival_time) OR 
            (t2.arrival_time > t1.departure_time and t2.departure_time > t1.departure_time))
),
concurrent_trains AS (
    SELECT   train_id, COUNT(*) AS concurrent_train_count
    FROM     common_trains
    GROUP BY 1
    ORDER BY 1
)
SELECT MAX(concurrent_train_count) + 1 AS min_num_platforms_reqd
FROM   concurrent_trains