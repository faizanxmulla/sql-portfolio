-- distance per each traveller 
-- order by distance desc, NAME 

SELECT   distinct u.name, IFNULL(sum(r.distance), 0) as travelled_distance
FROM     Users u LEFT JOIN Rides r on u.id=r.user_id
GROUP BY r.user_id
ORDER BY 2 DESC, 1


-- remarks: 
-- was joining using the wrong keys. 
-- also IFNULL is NOT a function in PostgreSQL. it works only in MySQL.

