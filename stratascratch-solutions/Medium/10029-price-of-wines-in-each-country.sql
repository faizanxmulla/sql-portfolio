WITH wines_corpus as (
    SELECT country, id, price
    FROM   winemag_p1
    UNION 
    SELECT country, id, price
    FROM   winemag_p2
)
SELECT   country, MIN(price) as min_price, AVG(price) as avg_price, MAX(price) as max_price
FROM     wines_corpus
GROUP BY country