SELECT distinct business_name,
       CASE 
            WHEN lower(business_name) ILIKE '%restaurant%' THEN 'restaurant'
            WHEN lower(business_name) ILIKE ANY(ARRAY['%cafe%','%café%','%coffee%']) THEN 'cafe'
            WHEN lower(business_name) ILIKE '%school%' THEN 'school'
            ELSE 'other'
        END as business_type
FROM   sf_restaurant_health_violations



-- NOTE: didn't know how to write multiple conditions + wasn't using DISTINCT