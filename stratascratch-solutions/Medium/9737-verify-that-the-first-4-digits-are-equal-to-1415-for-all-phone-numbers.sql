SELECT COUNT(business_name)
FROM   sf_restaurant_health_violations
WHERE  business_phone_number IS NOT NULL 
       and business_phone_number::varchar NOT LIKE '1415%'



-- NOTE: 
-- could have also used the LEFT clause : LEFT(business_phone_number::varchar, 4) != '1415'