WITH inspections_count_cte AS (
    SELECT   EXTRACT(YEAR FROM inspection_date) AS year,
             EXTRACT(MONTH FROM inspection_date) AS month,
             business_id, 
             COUNT(inspection_id) AS inspection_count
    FROM     sf_restaurant_health_violations
    WHERE    business_postal_code='94102'
    GROUP BY 1, 2, 3
)
SELECT   year, 
         SUM(inspection_count) AS total_inspections
FROM     inspections_count_cte
WHERE    month IN (1, 5, 11)
GROUP BY 1


-- REMARKS: 
-- not sure about the "Expected Output" format. so resulting "result set" may be wrong; but the query is correct. 