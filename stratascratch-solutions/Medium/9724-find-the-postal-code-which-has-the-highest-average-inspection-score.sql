WITH ranked_avg_scores as (
    SELECT   business_postal_code as postal_code,
             AVG(inspection_score) as avg_score,
             RANK() OVER(ORDER BY AVG(inspection_score) desc) as rn
    FROM     sf_restaurant_health_violations
    GROUP BY 1
)
SELECT postal_code, avg_score
FROM   ranked_avg_scores
WHERE  rn=1



-- NOTE: solved on first attempt