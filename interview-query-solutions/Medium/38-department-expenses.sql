-- correct solution // third attempt

WITH CTE as (
    SELECT   d.name as department_name, 
             SUM(CASE WHEN e.date BETWEEN '2022-01-01' and '2022-12-31' THEN e.amount ELSE 0 END) as total_expense
    FROM     departments d LEFT JOIN expenses e ON e.department_id=d.id
    GROUP BY 1
) 
SELECT   department_name,
         total_expense,
         ROUND(AVG(total_expense) OVER(), 2) as average_expense
FROM     CTE
ORDER BY total_expense desc


-- NOTE: 
-- didnt do LEFT JOIN initially
-- also didn't have a case statement
-- didn't require a WHERE statement



-- initial attempt

SELECT   d.name as department_name, 
         SUM(e.amount) as total_expense,
         ROUND(AVG(SUM(e.amount)) OVER(), 2) as average_expense
FROM     expenses e JOIN departments d ON e.department_id=d.id
WHERE    e.date BETWEEN '2022-01-01' and '2022-12-31'
GROUP BY d.name



-- NOTE: 

-- solved on second attempt; 
-- initially was doing just AVG(e.amount) instead of AVG(SUM(e.amount))