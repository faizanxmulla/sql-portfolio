WITH violations AS (
    SELECT   business_id, 
             COUNT(*) AS num_violations 
    FROM     sf_restaurant_health_violations
    WHERE    risk_category='High Risk' 
    GROUP BY 1
    ORDER BY 2 DESC
),
max_violations AS (
    SELECT busINess_id 
    FROM   violations
    WHERE  num_violations IN (
                              SELECT max(num_violations) 
                              FROM   violations
                            )
)
SELECT sf.*
FROM   sf_restaurant_health_violations sf 
WHERE  sf.business_id IN (
                          SELECT business_id 
                          FROM   max_violations
                        )