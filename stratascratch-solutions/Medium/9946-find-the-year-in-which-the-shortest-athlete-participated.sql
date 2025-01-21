-- Solution 1: using MIN()

SELECT year, height
FROM   olympics_athletes_events
WHERE  height IS NOT NULL
       and height IN (
            SELECT MIN(height)
            FROM   olympics_athletes_events
       )



-- Solution 2: using ORDER BY and LIMIT

SELECT   year, height
FROM     olympics_athletes_events
WHERE    height IS NOT NULL
ORDER BY height 
LIMIT    1