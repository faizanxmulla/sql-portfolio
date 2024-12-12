WITH CTE as (
    SELECT   EXTRACT(MONTH FROM activity_date) as month,
             COUNT(*) as n_inspections,
             RANK() OVER(ORDER BY COUNT(*)) as rn
    FROM     los_angeles_restaurant_health_inspections
    GROUP BY month
)
SELECT month, n_inspections
FROM   CTE
WHERE  rn=1