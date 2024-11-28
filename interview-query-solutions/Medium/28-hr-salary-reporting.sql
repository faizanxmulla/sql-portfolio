SELECT   job_title,
         SUM(salary) as total_salaries,
         SUM(overtime_hours * overtime_rate) as total_overtime_payments,
         SUM(salary + (overtime_hours * overtime_rate)) as total_compensation
FROM     employees
GROUP BY job_title



-- NOTE: solved on first attempt