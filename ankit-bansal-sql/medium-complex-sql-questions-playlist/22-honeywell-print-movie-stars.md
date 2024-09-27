### Problem Statement

During the development of a movie streaming service, a query is needed to return a list of movie genres and the best movie in that genre based on the maximum average review rating. 

The result should have the following columns:  `genre`, `title`, `stars`

The result should be sorted in ascending order by `genre`.



### Schema Setup

```sql
CREATE TABLE movies (
    id INT PRIMARY KEY,
    genre VARCHAR(50),
    title VARCHAR(100)
);

CREATE TABLE reviews (
    movie_id INT,
    rating DECIMAL(3,1),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);


INSERT INTO movies (id, genre, title) VALUES
(1, 'Action', 'The Dark Knight'),
(2, 'Action', 'Avengers: Infinity War'),
(3, 'Action', 'Gladiator'),
(4, 'Action', 'Die Hard'),
(5, 'Action', 'Mad Max: Fury Road'),
(6, 'Drama', 'The Shawshank Redemption'),
(7, 'Drama', 'Forrest Gump'),
(8, 'Drama', 'The Godfather'),
(9, 'Drama', 'Schindler''s List'),
(10, 'Drama', 'Fight Club'),
(11, 'Comedy', 'The Hangover'),
(12, 'Comedy', 'Superbad'),
(13, 'Comedy', 'Dumb and Dumber'),
(14, 'Comedy', 'Bridesmaids'),
(15, 'Comedy', 'Anchorman: The Legend of Ron Burgundy');


INSERT INTO reviews (movie_id, rating) VALUES
(1, 4.5), (1, 4.0), (1, 5.0), (2, 4.2), (2, 4.8), (2, 3.9), (3, 4.6), (3, 3.8), (3, 4.3), (4, 4.1), (4, 3.7), (4, 4.4), (5, 3.9), (5, 4.5), (5, 4.2), (6, 4.8), (6, 4.7), (6, 4.9), (7, 4.6), (7, 4.9), (7, 4.3), (8, 4.9), (8, 5.0), (8, 4.8), (9, 4.7), (9, 4.9), (9, 4.5), (10, 4.6), (10, 4.3), (10, 4.7), (11, 3.9), (11, 4.0), (11, 3.5), (12, 3.7), (12, 3.8), (12, 4.2), (13, 3.2), (13, 3.5), (13, 3.8), (14, 3.8), (14, 4.0), (14, 4.2), (15, 3.9), (15, 4.0), (15, 4.1);
```


### Expected Output

| genre  | title             | stars  |
|--------|-------------------|--------|
| Action | The Dark Knight   | *****  |
| Comedy | Bridesmaids       | ****   |
| Drama  | The Godfather     | *****  |




### Solution

```sql
WITH ranked_movies as (
	SELECT   genre, 
             title, 
             AVG(rating) as avg_rating, 
             ROW_NUMBER() OVER(PARTITION BY genre ORDER BY AVG(rating) desc) as rn
	FROM     movies m JOIN reviews r ON m.id=r.movie_id
	GROUP BY 1, 2
)
SELECT genre, title, REPEAT('*', ROUND(avg_rating, 0)::int) AS stars
FROM   ranked_movies
WHERE  rn=1


-- NOTE: learnt about new function: REPEAT
```