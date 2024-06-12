WITH top_genre_cte AS (
    SELECT   top_genre, COUNT(movie) FILTER(WHERE winner='True') AS nominee_count
    FROM     oscar_nominees o JOIN nominee_information ni ON o.nominee=ni.name
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT    1
)
SELECT top_genre
FROM   top_genre_cte