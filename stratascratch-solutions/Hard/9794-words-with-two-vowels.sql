WITH compiled_corpus AS (
    SELECT UNNEST(STRING_TO_ARRAY(words1, ',')) AS words
    FROM   google_word_lists
    UNION ALL
    SELECT UNNEST(STRING_TO_ARRAY(words2, ',')) AS words
    FROM   google_word_lists
),
vowels_count_cte AS (
    SELECT DISTINCT words, LENGTH(regexp_replace(words,'[^aeiou]','','g')) AS num_of_vowels
    FROM   compiled_corpus
)
SELECT   words
FROM     vowels_count_cte
WHERE    num_of_vowels=2
ORDER BY 1