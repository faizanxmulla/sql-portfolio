WITH employers_cte AS (
    SELECT *, LEAD(employer) OVER(PARTITION BY user_id ORDER BY start_date) as next_employer
    FROM   linkedin_users
)
SELECT COUNT(DISTINCT user_id) AS employee_count
FROM   employers_cte
WHERE  employer='Microsoft' AND next_employer='Google'