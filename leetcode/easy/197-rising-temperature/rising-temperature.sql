SELECT A.id
FROM Weather A ,Weather B
WHERE DATEDIFF(A.recordDate, B.recordDate) = 1 and A.temperature > B.temperature




# SELECT id
# FROM Weather 
# WHERE 
#     (SELECT d1, d2
#     FROM Weather 
#     WHERE DATEDIFF(d1, d2) = 1)