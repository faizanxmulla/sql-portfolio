SELECT   business_postal_code, 
         COUNT(distinct 
                    CASE
                         WHEN LEFT(business_address, 1) ~ '^[0-9]'
                         THEN LOWER(SPLIT_PART(business_address, ' ', 2))
                         ELSE LOWER(SPLIT_PART(business_address, ' ', 1))
                    END
            ) as n_streets
FROM     sf_restaurant_health_violations
WHERE    business_postal_code IS NOT NULL
GROUP BY business_postal_code
ORDER BY n_streets desc, business_postal_code




-- NOTE: was a bit confusing; couldn't solve the case statement on my own