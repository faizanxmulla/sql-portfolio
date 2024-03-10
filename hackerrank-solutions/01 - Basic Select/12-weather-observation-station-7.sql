-- Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

SELECT DISTINCT city
FROM Station
WHERE city REGEXP '.*[aeiou]$'


-- also can use : SUBSTR() function.

-- for other solutions/approaches, do refer the previous question's solution.