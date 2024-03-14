-- You're given a dataset of searches for properties on Airbnb. For simplicity, let's say that each search result (i.e., each row) represents a unique host. 

-- Find the city with the most amenities across all their host's properties. Output the name of the city.



SELECT   city
FROM     airbnb_search_details
GROUP BY 1, length(amenities)
ORDER BY length(amenities) desc
LIMIT    1



-- remarks: 

-- initial approach was : sum(REGEXP_SPLIT_TO_TABLE(amenities, ',')) 
-- but then realized it is much simpler using length function.


-- other approaches: 

-- 1. TRIM(UNNEST(STRING_TO_ARRAY(amenities, ',')), '{, ", }') AS split_amenities
-- 2. unnest(string_to_array(amenities,',')
-- 3. SUM((LENGTH(amenities) - LENGTH(REPLACE(amenities, ',', '')) + 1)
-- 4. sum(array_length(string_to_array(amenities, ','),1))
