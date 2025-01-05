WITH CTE as (
    SELECT first_name, department
    FROM   worker
    WHERE  department = 'HR'
)
SELECT * 
FROM   CTE 
UNION ALL 
SELECT * 
FROM   CTE



-- NOTE: initially wasn't sure what is being asked in the question; 