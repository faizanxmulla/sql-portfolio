SELECT title, TRIM(SUBSTRING(title from '\d{4}'))::numeric as year
FROM   winemag_p2
WHERE  country='Macedonia'



-- alternative solutions:

-- 2. NULLIF(regexp_replace(title, '\D','','g'), '')
-- 3. SUBSTRING(title, '[0-9]+')
-- 4. REGEXP_SUBSTR(title, '\d+')