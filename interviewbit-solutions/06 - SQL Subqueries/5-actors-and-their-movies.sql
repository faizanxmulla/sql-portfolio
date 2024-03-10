-- Write a SQL Query to find the name of those movies where one or more actors acted in two or more movies.

-- Solution 1:

SELECT m.movie_title
FROM   movies m,
       movies_cast mc
WHERE  m.movie_id = mc.movie_id
       AND c.actor_id IN (SELECT   actor_id
                          FROM     movies_cast
                          GROUP BY actor_id
                          HAVING   Count(*) > 1) 


-- Solution 2: 

SELECT movie_title
FROM   movies m JOIN movies_cast mc1 USING(movie_id)
WHERE  EXISTS (
       SELECT * 
       FROM   movies_cast mc2
       WHERE  mc1.actor_id=mc2.actor_id and mc1.movie_id!=mc2.movie_id
)


-- Solution 3: 

SELECT movie_title
FROM   movies
WHERE  movie_id IN (SELECT movie_id
                    FROM   movies_cast
                    WHERE  actor_id IN (SELECT actor_id
                                        FROM   actors
                                        WHERE  actor_id IN (SELECT   actor_id
                                                            FROM     movies_cast
                                                            GROUP BY actor_id
                                                            HAVING   Count(*) >= 2
                                                           )));