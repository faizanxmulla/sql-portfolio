WITH search_details
     AS (SELECT country,
                Sum(num_search) AS total_search,
                Sum(num_search * (invalid_result_pct / 100 )) AS invalid_searches
         FROM   search_category
         WHERE  num_search IS NOT NULL AND invalid_result_pct IS NOT NULL
         GROUP  BY 1)
SELECT country,
       total_search,
       Round(invalid_searches / total_search * 100.0, 2) as invalid_result_pct
FROM   search_details




-- my approach:

SELECT   country,
         SUM(num_search) as total_search,
         ROUND(100.0 * num_search * invalid_result_pct / SUM(num_search), 2) as invalid_result_pct
FROM     search_category
WHERE    num_search IS NOT NULL AND invalid_result_pct IS NOT NULL
GROUP BY 1