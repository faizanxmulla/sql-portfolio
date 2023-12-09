SELECT id, movie, description, rating
FROM Cinema
WHERE MOD(id, 2) = 1 and description <> 'boring'
ORDER BY 4 DESC


# another way : 
# WHERE MOD(id, 2) = 1