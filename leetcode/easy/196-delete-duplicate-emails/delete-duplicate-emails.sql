DELETE p2
FROM Person p1, Person p2 
WHERE p1.Email = p2.Email and p1.Id < p2.Id


# alternate solution : 

# DELETE
# FROM Person 
# WHERE id NOT IN (select min(id) as id 
#                  from Person 
#                  group by email)


# Solution using WINDOW function : (much FASTER)

# DELETE FROM Person
# WHERE id IN (SELECT id
#             FROM  
#               (SELECT id,  ROW_NUMBER() OVER(PARTITION BY email ORDER BY id) row_num
#               FROM Person) sq 
#             WHERE row_num > 1)