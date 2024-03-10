-- Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY REGEXP '^[^AEIOU]|[^aeiou]$'


-- "|" is for the "OR" condition.
-- link to refer regex negation : https://datacadamia.com/lang/regexp/negation