SELECT   country,
         SUM(CASE WHEN designation IS NULL THEN 1 ELSE 0 END) as total_without_designation,
         COUNT(*) - SUM(CASE WHEN designation IS NULL THEN 1 ELSE 0 END) as total_with_designation,
         COUNT(*) AS grand_total
FROM     winemag_p2
GROUP BY country
