WITH ranked_prices as (
    SELECT neighbourhood, RANK() OVER(ORDER BY price) as rn
    FROM   airbnb_search_details
    WHERE  bed_type='Real Bed'
           and property_type='Villa'
           and amenities ILIKE '%internet%'
)
SELECT neighbourhood
FROM   ranked_prices
WHERE  rn=1



-- NOTE: 

-- for the amenities part was initially doing UNNEST(STRING_TO_ARRAY(...));
-- but realized there was no need and it can be simply done with ILIKE or LIKE.