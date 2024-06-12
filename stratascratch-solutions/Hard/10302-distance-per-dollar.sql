WITH daily_dpd AS (
    SELECT request_date,
           distance_to_travel / monetary_cost::FLOAT AS distance_per_dollar
    FROM   uber_request_logs
),
sum_distance_monetary AS (
    SELECT   TO_CHAR(request_date, 'YYYY-MM') AS year_month,
             SUM(distance_to_travel) AS sum_distance_per_travel,
             SUM(monetary_cost) AS sum_monetary_cost
    FROM     uber_request_logs
    GROUP BY 1
),
monthly_dpd AS (
    SELECT year_month,
           sum_distance_per_travel / sum_monetary_cost::FLOAT AS distance_per_dollar
    FROM   sum_distance_monetary
),
compare_monthly_daily_dpd AS (
    SELECT request_date, ABS(d.distance_per_dollar - m.distance_per_dollar) AS difference
    FROM   daily_dpd d JOIN monthly_dpd m ON TO_CHAR(d.request_date, 'YYYY-MM') = m.year_month
)
SELECT   TO_CHAR(request_date, 'YYYY-MM') AS request_month,
         ROUND(AVG(difference)::numeric, 2) AS difference
FROM     compare_monthly_daily_dpd
GROUP BY 1
ORDER BY 1