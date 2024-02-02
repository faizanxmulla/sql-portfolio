-- Query the two cities in STATION with the shortest and longest CITY names, as well as their respective LENGTHs (i.e.: number of charaCTErs in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.

-- first thoughts/ immediate approach : 
SELECT MAX(CHAR_LENGTH(city)), MIN(CHAR_LENGTH(city))
FROM Station

-- but this displays only the length of the max/min length cities and not the cities themselves. 


-- Solution 1: two separate queries

SELECT
  CITY,
  LENGTH(CITY)
FROM
  STATION
ORDER BY
  Length(CITY) ASC,
  CITY
LIMIT
  1;
SELECT
  CITY,
  LENGTH(CITY)
FROM
  STATION
ORDER BY
  Length(CITY) DESC,
  CITY
LIMIT
  1;


-- stackoverflow : https://stackoverflow.com/questions/39129585/query-the-two-cities-in-station-with-the-shortest-and-longest-city-names

-- Solution 2 : using CTE & ROW_NUMBER analytic function.

WITH CTE as (
  SELECT
    city,
    LENGTH(city) as len,
    ROW_NUMBER() OVER (
      ORDER BY
        LENGTH(city), city
    ) as smallest_rn,
    ROW_NUMBER() OVER (
      ORDER BY
        LENGTH(city) DESC,
        city
    ) as largest_rn
  FROM
    station
)

SELECT
  city,
  len
FROM
  CTE
where
  smallest_rn = 1
union all
SELECT
  city,
  len
FROM
  CTE
where
  largest_rn = 1