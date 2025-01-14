WITH ranked_targets as (
    SELECT first_name,
           target,
           bonus, 
           DENSE_RANK() OVER(ORDER BY target desc) as rn
    FROM   employee
)
SELECT first_name, target, bonus
FROM   ranked_targets
WHERE  rn=1