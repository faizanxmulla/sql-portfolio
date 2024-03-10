-- Given a table FIREFIGHTERS, find the largest difference between the number of people saved by 2 firefighters.


SELECT MAX(a.PeopleSaved - b.PeopleSaved) as A
FROM   FIREFIGHTERS a, FIREFIGHTERS b