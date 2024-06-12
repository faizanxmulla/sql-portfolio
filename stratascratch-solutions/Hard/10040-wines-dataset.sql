WITH CTE AS (
    SELECT   country, SUM(points) AS total_points
    FROM     winemag_p1
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT    1
)
SELECT *
FROM   winemag_p1
WHERE  country IN (
      SELECT country
      FROM   CTE
    )