WITH ranked_salaries as (
    SELECT start_date, RANK() OVER(ORDER BY yearly_salary desc) as rn
    FROM   lyft_drivers
    WHERE  end_date IS NULL
)
SELECT start_date
FROM   ranked_salaries
WHERE  rn <= 5