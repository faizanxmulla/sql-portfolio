SELECT   EXTRACT(DOW FROM ds_checkin) as day_of_week,
         COUNT(*) as checkin_count
FROM     airbnb_contacts
GROUP BY 1
ORDER BY 2 desc
LIMIT    1