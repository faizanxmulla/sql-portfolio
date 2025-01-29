-- Solution 1: using recursive cte

WITH RECURSIVE CTE as (
    SELECT int_numbers, 1 as flag
    FROM   tbl_numbers
    UNION ALL
    SELECT int_numbers, flag+1
    FROM   CTE
    WHERE  flag < int_numbers
)
SELECT   int_numbers as seq_numbers
FROM     CTE
ORDER BY 1



-- Solution 2: very easy in PostgreSQL
-- using CROSS join & generate_series

SELECT int_numbers AS seq_numbers 
FROM   tbl_numbers CROSS JOIN generate_series(1, int_numbers)


-- NOTE: read the question and immendiately thought of recursive cte.