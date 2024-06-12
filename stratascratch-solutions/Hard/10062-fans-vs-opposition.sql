-- Solution 1:

WITH ranked_employees AS (
    SELECT *, 
           COUNT(*) OVER() AS total_employees,
           ROW_NUMBER() OVER(ORDER BY popularity DESC, employee_id) AS rn
    FROM   facebook_hack_survey
)
SELECT e1.employee_id AS fan, e2.employee_id AS opp
FROM   ranked_employees e1 JOIN ranked_employees e2 
ON     e1.rn + e2.rn= (e2.total_employees + 1) AND 
       e1.employee_id != e2.employee_id



-- Solution 2: alternative (my approach initially)

WITH fans AS (
    SELECT employee_id, 
           ROW_NUMBER() OVER(ORDER BY popularity DESC, employee_id) AS rn
    FROM   facebook_hack_survey
),
opponents AS (
    SELECT employee_id, 
           ROW_NUMBER() OVER(ORDER BY popularity ASC, employee_id) AS rn
    FROM   facebook_hack_survey
)
SELECT fans.employee_id AS fan, opponents.employee_id AS opp
FROM   fans JOIN opponents ON fans.rn = opponents.rn



-- also this query; seems similar to solution 2 but gives different result set.

WITH ranked_employees AS (
    SELECT employee_id, 
           ROW_NUMBER() OVER(ORDER BY popularity DESC) AS fan_rn,
           ROW_NUMBER() OVER(ORDER BY popularity) AS opp_rn
    FROM   facebook_hack_survey
)
SELECT e1.employee_id AS fan, e2.employee_id AS opp
FROM   ranked_employees e1 JOIN ranked_employees e2 ON e1.fan_rn = e2.opp_rn



