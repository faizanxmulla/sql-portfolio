-- Given 2 tables ENGINEER and DATA, query the sum of Count of all the engineers whose Type is FrontEnd.

-- Note: The column ID is the same in both the tables.


SELECT SUM(e.Count) as A
FROM   DATA d INNER JOIN ENGINEER e USING(ID)
WHERE  d.Type='FrontEnd'