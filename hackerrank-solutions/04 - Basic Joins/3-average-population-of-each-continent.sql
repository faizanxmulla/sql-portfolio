-- Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.


SELECT   co.CONTINENT, FLOOR(AVG(ci.POPULATION))
FROM     CITY ci JOIN COUNTRY co ON ci.CountryCode = co.Code 
GROUP BY 1



-- remarks : didn't read the question carefully and was trying ROUND instead of FLOOR.