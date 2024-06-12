-- Solution 1: 

WITH all_words_corpus AS (
    SELECT contents AS text
    FROM   google_file_store
    UNION ALL
    SELECT words1 AS text
    FROM   google_word_lists
    UNION ALL
    SELECT words2 AS text
    FROM   google_word_lists
),
letters_extracted AS (
    SELECT LOWER(SUBSTRING(text, i, 1)) AS letter
    FROM   all_words_corpus JOIN generate_series(1, 10000) AS s(i) ON i <= LENGTH(text)
)
SELECT   letter, COUNT(*) AS occurrences
FROM     letters_extracted
WHERE    letter ~ '[a-z]'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    3


-- OR -- 


-- Solution 2: 

with all_letters as 
(
    SELECT LOWER(UNNEST(regexp_split_to_array(contents, ''))) as letters
    FROM   google_file_store
    UNION ALL
    SELECT LOWER(UNNEST(regexp_split_to_array(CONCAT(words1, ' ', words2), ''))) as letters
    FROM   google_word_lists
)
SELECT   letter, COUNT(*) AS occurrences
FROM     all_letters
WHERE    letters <> ' '
GROUP BY 1
ORDER BY 2 DESC
LIMIT    3

