WITH total_cte AS (
    SELECT COUNT(*) AS total_count
    FROM   lyft_rides
),
wh_cte AS (
    SELECT   weather, hour, COUNT(*) AS wh_count
    FROM     lyft_rides
    GROUP BY 1, 2
    ORDER BY 1, 2
)
SELECT   wh.weather, wh.hour, (wh.wh_count / t.total_count::FLOAT) AS fraction
FROM     total_cte AS t, wh_cte AS wh
ORDER BY 1, 2