WITH words1_corpus AS (
    SELECT UNNEST(STRING_TO_ARRAY(words1, ',')) AS words
    FROM   google_word_lists
),
words2_corpus AS (
    SELECT UNNEST(STRING_TO_ARRAY(words2, ',')) AS words
    FROM   google_word_lists
)
SELECT words 
FROM   words1_corpus
WHERE  words IN (SELECT words 
                 FROM   words2_corpus)