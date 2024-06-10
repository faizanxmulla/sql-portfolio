WITH types_of_rooms as (
    SELECT DISTINCT *,
           UNNEST(STRING_TO_ARRAY(filter_room_types,',')) as room_types
    FROM   airbnb_searches
)
SELECT   room_types, COUNT(*) as number_of_searches
FROM     types_of_rooms
WHERE    LENGTH(room_types) > 0
GROUP BY 1
ORDER BY 2 DESC