WITH employee_earnings AS (
    SELECT adwords_earnings / n_employees AS earning_per_employee
    FROM   google_adwords_earnings
    WHERE  business_type='handyman' AND n_employees < 10
)
SELECT   earning_per_employee, COUNT(*) AS count
FROM     employee_earnings
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1