-- Write a SQL Query to find those lowest duration movies along with the year, director’s name(first and last name combined), actor’s name(first and last name combined) and his/her role in that production.

-- Output Schema:
-- movie_title,movie_year,director_name,actor_name,role
-- Vertigo,1958,AlfredHitchcock,JamesStewart,JohnFerguson


SELECT movie_title,
       movie_year,
       Concat(director_first_name, director_last_name) AS director_name,
       Concat(actor_first_name, actor_last_name)       AS actor_name,
       role
FROM   directors
       JOIN movies_directors USING(director_id)
       JOIN movies USING(movie_id)
       JOIN movies_cast USING(movie_id)
       JOIN actors USING(actor_id)
WHERE  movie_time IN (SELECT Min(movie_time)
                      FROM   movies) 


-- other approach : 

ORDER BY movie_time
LIMIT    1


