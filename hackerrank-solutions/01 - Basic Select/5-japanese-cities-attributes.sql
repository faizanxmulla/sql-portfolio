-- Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.

SELECT
  *
FROM
  City
WHERE
  countrycode = 'JPN'