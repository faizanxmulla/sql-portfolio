-- Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.

SELECT
  DISTINCT City
FROM
  Station
WHERE
  id % 2 = 0