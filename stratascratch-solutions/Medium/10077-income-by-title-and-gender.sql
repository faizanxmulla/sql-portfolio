WITH get_total_bonus as (
    SELECT   worker_ref_id, SUM(bonus) as total_bonus
    FROM     sf_bonus
    GROUP BY worker_ref_id
)
SELECT   employee_title, sex, AVG(salary + total_bonus) as avg_compensation
FROM     sf_employee e RIGHT JOIN get_total_bonus tb ON e.id=tb.worker_ref_id
GROUP BY employee_title, sex



-- NOTE: solved on the very first attempt