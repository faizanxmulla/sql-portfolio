WITH CTE AS (
    SELECT   UNNEST(STRING_TO_ARRAY(lower(contents),' ')) as contents
    FROM     google_file_store
    WHERE    filename='final.txt'
    ORDER BY 1
)
SELECT 'wacky.txt' AS filename, ARRAY_TO_STRING(ARRAY_AGG(contents) ,' ') as contents
FROM   CTE


-- REMARKS: 

-- if we had to handle the punctuation marks, we can do it in the following manner --> 
-- regexp_replace(lower(contents), '[^\w\s]', '', 'g'), ' '