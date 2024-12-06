SELECT   city, AVG(accommodates::float / beds::float) as avg_crowdness_ratio
FROM     airbnb_search_details
WHERE    room_type='Shared room'
GROUP BY 1
ORDER BY 2 desc



-- NOTE: same mistake as prev question; didn't cast to float