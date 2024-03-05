-- Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.


SELECT ci.NAME
FROM   CITY ci JOIN COUNTRY co ON ci.CountryCode = co.Code 
WHERE  co.CONTINENT='Africa'