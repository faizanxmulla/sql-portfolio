-- Write a SQL Query to find the movie_title and name of director (first and last names combined) who directed a movie that casted a role as ‘SeanMaguire’.


SELECT Concat(director_first_name, director_last_name) AS director_name,
       movie_title
FROM   directors
       JOIN movies_directors USING(director_id)
       JOIN movies USING(movie_id)
       JOIN movies_cast USING(movie_id)
WHERE  role = 'SeanMaguire' 