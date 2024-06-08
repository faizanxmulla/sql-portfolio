-- todays obsv. = last obsv. --> LAG
-- distance per dollar = distance / monetary cost
-- monthly level --> GB month
-- calculate RMSE


WITH distance_per_dollar AS (
    SELECT   EXTRACT(MONTH FROM request_date) AS month, 
             SUM(distance_to_travel) / SUM(monetary_cost) AS actual_values
    FROM     uber_request_logs
    GROUP BY 1
    ORDER BY 1
),
naive_forecast AS (
    SELECT *, LAG(actual_values) OVER(ORDER BY month) AS forecasted_values
    FROM   distance_per_dollar
)
SELECT ROUND(SQRT(AVG((actual_values - forecasted_values)^2)::NUMERIC), 2) AS rmse
FROM   naive_forecast