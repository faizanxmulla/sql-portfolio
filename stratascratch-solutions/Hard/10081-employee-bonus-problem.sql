WITH employee_bonus AS (
    SELECT DISTINCT id,
           CASE WHEN worker_ref_id IS NULL THEN 0 ELSE 1 END AS has_bonus
    FROM   employee e LEFT JOIN bonus b ON e.id = b.worker_ref_id
)
SELECT   has_bonus, COUNT(id) as num_employees
FROM     employee_bonus
GROUP BY 1