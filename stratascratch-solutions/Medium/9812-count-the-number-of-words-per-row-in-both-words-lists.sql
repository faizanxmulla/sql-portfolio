WITH numbered_list as (
    SELECT words1, words2, ROW_NUMBER() OVER() as rn
    FROM   google_word_lists
)
, get_all_words as (
    SELECT   STRING_AGG(words1 || ',' || words2, ',') AS all_words
    FROM     numbered_list
    GROUP BY rn
    -- ORDER BY rn
)
SELECT ARRAY_LENGTH(STRING_TO_ARRAY(all_words, ','), 1) as n_words
FROM   get_all_words



-- NOTE: couldn't figure out the STRING_AGG() function by myself.