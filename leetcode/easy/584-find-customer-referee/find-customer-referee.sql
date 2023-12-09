SELECT name
FROM Customer 
WHERE referee_id <> 2 or referee_id is null

# OR 

# SELECT name
# FROM Customer
# WHERE COALESCE(referee_id,0) <> 2;