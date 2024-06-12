-- my solution (solved in first attempt): long but very easy to understand

WITH bull_count_cte AS (
    SELECT   filename, COUNT(contents) as bull_occurences
    FROM     google_file_store
    WHERE    contents LIKE '%bull%'
    GROUP BY 1
),
bear_count_cte AS (
    SELECT   filename, COUNT(contents) as bear_occurences
    FROM     google_file_store 
    WHERE    contents LIKE '%bear%'
    GROUP BY 1
)
SELECT   'bull' as word, SUM(bull_occurences) AS nentry
FROM     bull_count_cte
GROUP BY 1
UNION 
SELECT   'bear' as word, SUM(bear_occurences) AS nentry
FROM     bear_count_cte
GROUP BY 1
ORDER BY 2 DESC



-- more easy solution: (learnt something new)

SELECT word, nentry                                       
FROM   ts_stat('SELECT to_tsvector(contents) FROM google_file_store') 
WHERE  word ILIKE 'bull' or word ILIKE 'bear'