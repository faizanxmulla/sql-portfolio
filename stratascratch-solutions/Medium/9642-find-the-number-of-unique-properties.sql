SELECT DISTINCT UNNEST(STRING_TO_ARRAY(TRIM(filter_room_types, ','), ',')) as property_type
FROM   airbnb_searches



-- NOTE: didn't use TRIM initially; so was getting 4 records instead of 3.