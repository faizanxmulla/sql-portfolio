WITH low_rating_queries as (
    SELECT   query
    FROM     search_results
    GROUP BY query
    HAVING   MAX(rating) < 3
) 
SELECT ROUND(1.0 * COUNT(DISTINCT lr.query) / COUNT(DISTINCT sr.query), 2) as percentage_less_than_3
FROM   search_results sr LEFT JOIN low_rating_queries lr ON sr.query = lr.query



-- can also do this: SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) = COUNT(*) in the HAVING clause