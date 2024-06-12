WITH service_length AS (
    SELECT EXTRACT(days FROM (COALESCE(end_date, NOW()) - start_date)) AS length_of_service,
           yearly_salary
    FROM   lyft_drivers
)
SELECT CORR(length_of_service, yearly_salary) AS correlation
FROM   service_length