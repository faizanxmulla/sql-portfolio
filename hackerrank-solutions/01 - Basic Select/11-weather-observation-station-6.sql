-- Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) FROM STATION. Your result cannot contain duplicates.


-- my solution : first thought was using the obvious LIKE i.e. LIKE '[AEIOU]%', but not working with MySQL (works finr with MS SQL server)

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY REGEXP '^[AEIOU]'


-- Solution 2: (creative)

SELECT DISTINCT CITY 
FROM STATION 
WHERE UPPER(LEFT(CITY, 1)) IN ('A', 'E', 'I', 'O', 'U')


-- Solution 3: using OR (my second thought)

SELECT city 
FROM Station
WHERE (city LIKE 'a%' OR city LIKE 'e%' OR city LIKE 'i%' OR city LIKE 'o%' OR city LIKE 'u%');


-- Solution 4: postgres solution

SELECT DISTINCT s.CITY
FROM STATION s
WHERE LOWER(s.CITY) SIMILAR TO '(a|e|i|o|u)%';


-- Solution 5: using UNION (but too long --> not preferred)

SELECT city FROM Station WHERE City LIKE 'a%'
union
SELECT city FROM Station WHERE City LIKE 'e%'
union
SELECT city FROM Station WHERE City LIKE 'i%'
union
SELECT city FROM Station WHERE City LIKE 'o%'
union
SELECT city FROM Station WHERE City LIKE 'u%';

