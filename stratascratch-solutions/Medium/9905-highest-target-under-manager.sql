WITH ranked_targets as (
    SELECT first_name,
           target,
           DENSE_RANK() OVER(ORDER BY target desc) as rn
    FROM   salesforce_employees
    WHERE  manager_id=13
)
SELECT first_name, target
FROM   ranked_targets
WHERE  rn=1