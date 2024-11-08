SELECT first_name,
       last_name,
       (COALESCE(termination_date, '2021-05-01') - hire_date)::float / 365 as years_spent,
       CASE WHEN termination_date IS NULL THEN 'Yes' ELSE 'No' END as still_employed 
FROM   uber_employees
WHERE  (COALESCE(termination_date, '2021-05-01') - hire_date) > 730



-- NOTE: couldn't figure out to use COALESCE on my own.