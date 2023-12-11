SELECT MAX(num) as num
FROM 
    (SELECT num 
    FROM MyNumbers 
    GROUP BY 1
    HAVING COUNT(num) = 1
    ) table2


# link to 5-7 solutions : 
# https://leetcode.com/problems/biggest-single-number/solutions/3787911/5-7-easy-different-solutions/?envType=study-plan-v2&envId=top-sql-50