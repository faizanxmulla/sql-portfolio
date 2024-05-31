WITH ratings_cte as (
    SELECT   name, COUNT(rating) as number_of_ratings
    FROM     MovieRating mr JOIN Users u USING(user_id)
    GROUP BY 1
    ORDER BY 2 DESC, 1
    LIMIT    1
),
highest_avg AS (
    SELECT   title, AVG(rating) as avg
    FROM     Movies m JOIN MovieRating mr USING(movie_id)
    WHERE    TO_CHAR(created_at, 'YYYY-MM') = '2020-02'
    GROUP BY 1
    ORDER BY 2 DESC, 1
    LIMIT    1
)
SELECT name as results
FROM   ratings_cte

UNION ALL

SELECT title as results
FROM   highest_avg


-- NOTE: was using LENGTH to sort out lexicographically; but turns out it was not need at all. 