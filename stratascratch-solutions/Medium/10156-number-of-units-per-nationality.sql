SELECT   h.nationality, COUNT(distinct u.unit_id) as apartment_count
FROM     airbnb_hosts h JOIN airbnb_units u ON h.host_id=u.host_id
WHERE    h.age < 30 and u.unit_type='Apartment'
GROUP BY h.nationality
ORDER BY apartment_count desc