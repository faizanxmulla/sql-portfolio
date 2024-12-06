SELECT   id_host, AVG(ds_checkin::date - ts_booking_at::date) as avg_days_between_booking_and_checkin
FROM     airbnb_contacts
GROUP BY 1
HAVING   AVG(ds_checkin::date - ts_booking_at::date) >= 0
ORDER BY 2 DESC



-- NOTE: didn't cast to date in the initial attempt.