SELECT * 
FROM patients 
WHERE
    conditions LIKE '% DIAB1%' OR
    conditions LIKE 'DIAB1%';


# alternate solution --> conditions REGEXP '\\bDIAB1' or REGEXP_LIKE(conditions, '\\bDIAB1')

# explanation : "\b" matches either a non-word character (in our case, a space) and need to escape a backslash with another backslash, so then, "\\b". Also, "\b" also matches the position after the last character

