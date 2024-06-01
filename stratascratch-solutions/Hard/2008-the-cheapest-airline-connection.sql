WITH one_stage_flight AS (
    SELECT f1.origin,
           f2.destination,
           (f1.cost + f2.cost) AS total_cost
    FROM   da_flights AS f1 LEFT JOIN da_flights AS f2 ON f1.destination = f2.origin
    WHERE  (f1.cost + f2.cost) > 0
), 
two_stage_flight AS (
    SELECT f1.origin,
           f3.destination,
           (f1.cost + f2.cost + f3.cost) AS total_cost
    FROM   da_flights AS f1 LEFT JOIN da_flights AS f2 ON f1.destination = f2.origin
                            LEFT JOIN da_flights AS f3 ON f2.destination = f3.origin
    WHERE  (f1.cost + f2.cost + f3.cost) > 0
), 
all_flight_corpus AS (
    SELECT origin, destination, cost
    FROM   da_flights
    UNION ALL
    SELECT *
    FROM   one_stage_flight
    UNION ALL 
    SELECT *
    FROM   two_stage_flight
), 
rank_all_flight AS (
    SELECT origin, destination, cost,
           DENSE_RANK() OVER (PARTITION BY origin, destination ORDER BY cost) AS dr
    FROM   all_flight_corpus
)
SELECT   origin, destination, cost
FROM     rank_all_flight
WHERE    dr = 1
ORDER BY 1, 2