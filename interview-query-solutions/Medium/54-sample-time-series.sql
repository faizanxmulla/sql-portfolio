WITH CTE as (
    SELECT created_at, 
           product_id, 
           ROW_NUMBER() OVER(ORDER BY created_at) as rn
    FROM   transactions
)
SELECT created_at, product_id
FROM   CTE
WHERE  MOD(rn, 4) = 0



-- NOTE: weird that the same solution is giving different result sets when running in PostgreSQL vs MySQL.