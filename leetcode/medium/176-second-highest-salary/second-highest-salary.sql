SELECT max(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT max(salary) FROM Employee)


# alternate solutions : 
# --------------------------

# 1. 

# SELECT DISTINCT MAX(salary) AS SecondHighestSalary
# FROM Employee a
# WHERE Salary < (SELECT MAX(salary) FROM Employee b WHERE b.salary > a.salary)

# OR more easily 

# SELECT MAX(e2.Salary) as SecondHighestSalary
# FROM Employee e1, Employee e2
# WHERE e1.Salary > e2.Salary


# 2. 

# SELECT IFNULL((SELECT DISTINCT Salary
# 	             FROM Employee 
# 				 ORDER BY Salary DESC 
# 				 LIMIT 1,1),NULL) AS SecondHighestSalary


# 3. 

# SELECT MAX(a.Salary) as SecondHighestSalary
# FROM Employee a JOIN Employee b ON a.Salary < b.Salary


# 4. 

# SELECT DISTINCT salary
# FROM Employee a
# WHERE 2> (SELECT COUNT(DISTINCT salary) FROM Employee b WHERE b.salary > a.salary )
# ORDER BY 1 DESC
# LIMIT 2 OFFSET 1


# 5. using WINDOW function 

# WITH CTE AS (SELECT Salary, RANK () OVER (ORDER BY Salary desc) AS RANK_desc FROM Employee)

# SELECT MAX(salary) AS SecondHighestSalary
# FROM CTE
# WHERE RANK_desc = 2