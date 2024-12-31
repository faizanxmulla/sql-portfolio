SELECT   UNNEST(STRING_TO_ARRAY(TRANSLATE(contents, ',.', ''), ' ')) as word, COUNT(*)
FROM     google_file_store
WHERE    filename LIKE 'draft%'
GROUP BY word
ORDER BY word desc



-- NOTE: solved by myself.