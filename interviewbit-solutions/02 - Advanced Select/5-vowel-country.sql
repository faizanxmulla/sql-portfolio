-- Given a table PLACES, count the number of Countries which end with a vowel.

SELECT COUNT(Country)
FROM   PLACES 
WHERE  Country REGEXP '[aeiou]$'


-- similar to hackerrank --> Basic select --> last 7-8 problems, all based on REGEX. 