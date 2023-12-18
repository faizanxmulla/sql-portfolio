SELECT m.name 
FROM Employee e, Employee m 
WHERE m.id = e.managerId
GROUP BY e.managerId
HAVING COUNT(e.id) >= 5


# also can use INNER JOIN --> from employee as e inner join employee as m on e.managerId=m.id

# another solution using : SUBQUERY --> 

# SELECT m.name
# from Employee m
# WHERE m.id IN (
#     SELECT e.managerId 
#     FROM employee e
#     GROUP BY e.managerID
#     HAVING COUNT(e.id) >= 5
# )