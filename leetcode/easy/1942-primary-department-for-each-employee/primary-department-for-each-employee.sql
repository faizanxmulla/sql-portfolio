SELECT employee_id, department_id
FROM Employee
WHERE employee_id IN (
    SELECT employee_id
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(employee_id) = 1
) OR primary_flag = 'Y'
ORDER BY employee_id;



# alternate solutions -->

# 1. using WINDOW function : 

# SELECT EMPLOYEE_ID,DEPARTMENT_ID
# FROM
# (
# SELECT *,COUNT(EMPLOYEE_ID) OVER(PARTITION BY EMPLOYEE_ID) C
# FROM EMPLOYEE
# )T
# WHERE C=1 OR PRIMARY_FLAG='Y'


# 2. 

# select employee_id,coalesce(max(case when primary_flag='Y' then department_id else null end), max(department_id)) department_id

# from employee t
# group by employee_id


# 3. using UNION function : 

# SELECT employee_id, department_id
# FROM Employee 
# WHERE primary_flag='Y'

# UNION

# SELECT employee_id, department_id
# FROM Employee
# WHERE employee_id NOT IN (SELECT employee_id
#                           FROM Employee
#                           WHERE primary_flag = 'Y')

# GROUP BY employee_id
# HAVING COUNT(*)=1 