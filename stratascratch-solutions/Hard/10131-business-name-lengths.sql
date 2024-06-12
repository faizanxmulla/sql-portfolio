WITH replace_symbol AS (
    SELECT DISTINCT business_name,
           REGEXP_REPLACE(business_name, '[^a-zA-Z0-9 ]', '', 'g') AS only_word
    FROM   sf_restaurant_health_violations
)
SELECT   business_name,
         ARRAY_LENGTH(REGEXP_SPLIT_TO_ARRAY(only_word, '\s+'), 1) AS word_count
FROM     replace_symbol
ORDER BY 2 DESC