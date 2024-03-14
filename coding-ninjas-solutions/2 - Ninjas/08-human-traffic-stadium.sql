-- Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

-- Return the result table ordered by visit_date in ascending order.


WITH CTE AS (
    SELECT *, id-ROW_NUMBER() OVER(ORDER BY id) as row_num
    FROM   Stadium
    WHERE  people >= 100
)
SELECT id, visit_date, people
FROM   CTE
WHERE  row_num=(
    SELECT   row_num
    FROM     CTE
    GROUP BY 1
    HAVING   COUNT(*) >= 3
)


-- my approach:

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(ORDER BY id) as row_num
    FROM   Stadium
    WHERE  people >= 100
)

-- was stuck here. so, then thought of using LEAD and LAG, but that too didn't work out. 

WITH CTE as (
    SELECT id, LAG(id) OVER(ORDER BY id) as lag, LEAD(id) OVER(ORDER BY id) as lead, visit_date, people
    FROM   Stadium  
)

SELECT id, visit_date, people
FROM   CTE
WHERE  people >= 100 and


-- remarks: should have observed "id-ROW_NUMBER".