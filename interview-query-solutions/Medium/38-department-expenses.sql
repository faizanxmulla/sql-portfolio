SELECT   d.name as department_name, 
         SUM(e.amount) as total_expense,
         ROUND(AVG(SUM(e.amount)) OVER(), 2) as average_expense
FROM     expenses e JOIN departments d ON e.department_id=d.id
WHERE    e.date BETWEEN '2022-01-01' and '2022-12-31'
GROUP BY d.name



-- NOTE: 

-- solved on second attempt; 
-- initially was doing just AVG(e.amount) instead of AVG(SUM(e.amount))