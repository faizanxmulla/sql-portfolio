-- Given 2 tables ENGINEER and DATA, query for the total count of each Type in the ENGINEER table. Print the result in alphabetical order of the Type.

-- Note: The ID columns in both tables are identical.


SELECT   SUM(e.Count) as A
FROM     DATA d INNER JOIN ENGINEER e USING(ID)
GROUP BY d.Type
ORDER BY d.Type