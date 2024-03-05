-- Write a query to output the names of those students whose best friends got offered a higher salary than them. 

-- Names must be ordered by the salary amount offered to the best friends. 
-- It is guaranteed that no two students got same salary offer.


Select S.Name
From ( Students S join Friends F Using(ID)
       join Packages P1 on S.ID=P1.ID
       join Packages P2 on F.Friend_ID=P2.ID)
Where    P2.Salary > P1.Salary
Order By P2.Salary;



-- was trying this solution : basically the same but by using CTE instead of Subquery. but didn't work.

with cte as (
    SELECT *
    FROM   Students s JOIN Friends f USING(ID)
                      JOIN Packages p1 ON s.ID=p1.ID
                      JOIN Packages p2 ON f.Friend_ID=p2.ID
)
SELECT   Name
FROM     cte
WHERE    p2.Salary > p1.Salary
ORDER BY p2.Salary