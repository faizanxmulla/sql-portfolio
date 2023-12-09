SELECT id, movie, description, rating
FROM Cinema
WHERE id % 2 <> 0 and description <> 'boring'
ORDER BY 4 DESC