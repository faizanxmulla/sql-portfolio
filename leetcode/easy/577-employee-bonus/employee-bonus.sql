SELECT e.name, b.bonus
FROM Employee e LEFT JOIN Bonus b USING(empId)
WHERE b.bonus < 1000 or b.bonus is null 


#alternate solution : 
# 1. WHERE COALESCE(bonus, 0) < 1000; 
# 2. WHERE IFNULL(bonus, 0)<1000

