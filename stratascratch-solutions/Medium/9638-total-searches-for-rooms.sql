SELECT   city,  
         COUNT(id) FILTER(WHERE room_type ILIKE '%apt%') as apt_count,
         COUNT(id) FILTER(WHERE room_type ILIKE '%private%') as private_count,
         COUNT(id) FILTER(WHERE room_type ILIKE '%shared%') as shared_count
FROM     airbnb_search_details
GROUP BY city



-- NOTE: solved on first attempt