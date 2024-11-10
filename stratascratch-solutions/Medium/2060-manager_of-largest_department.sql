-- Solution 1: short

WITH CTE AS(
    SELECT   department_id,
             RANK() OVER (ORDER BY COUNT(id) DESC) as rn
    FROM     az_employees
    GROUP BY 1
)
SELECT first_name, last_name
FROM   az_employees JOIN cte USING(department_id)
WHERE  rn = 1 and position ILIKE ('%manager%')



-- Solution 2: same appraoch but longer

WITH dept_cte as (
    SELECT first_name,
           last_name,
           position, 
           department_name,
           COUNT(id) OVER(PARTITION BY department_id) as dept_count
    FROM   az_employees
),
ranked_counts as (
    SELECT *, RANK() OVER(ORDER BY dept_count desc) as rn
    FROM   dept_cte
)
SELECT first_name, last_name
FROM   ranked_counts
WHERE  position ilike '%manager%' and rn=1