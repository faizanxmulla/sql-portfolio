WITH variance_cte AS (
    SELECT (score - AVG(score) OVER())^2 AS error
    FROM   los_angeles_restaurant_health_inspections
    WHERE  grade = 'A'
)
SELECT AVG(error) AS variance, SQRT(AVG(error)) AS std_deviation
FROM   variance_cte