WITH wine_corpus AS (
    SELECT variety, price
    FROM   winemag_p1
    UNION ALL
    SELECT variety, price
    FROM   winemag_p2
)
SELECT   variety, PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY price) AS median_price
FROM     wine_corpus
GROUP BY 1
