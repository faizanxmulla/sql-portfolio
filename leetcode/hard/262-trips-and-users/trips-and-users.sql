SELECT   request_at AS "Day",
         ROUND((SUM(CASE WHEN Status != 'completed' THEN 1.00 ELSE 0 END) / COUNT(id)), 2) AS "Cancellation Rate"
FROM     Trips t JOIN Users u1 ON t.client_id = u1.users_id AND u1.banned = 'No'
                 JOIN Users u2 ON t.driver_id = u2.users_id AND u2.banned = 'No'
WHERE    t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY 1


-- my initial approach: 

-- SELECT   request_at as "Day",
--          ROUND(((SUM(CASE WHEN Status = 'completed' THEN 0 ELSE 1.00 END)) / COUNT(id)), 2) as "Cancellation Rate"
-- FROM     Trips t JOIN Users u ON (u.banned='No' and u.users_id=t.client_id or u.users_id=t.driver_id) 
-- WHERE    t.request_at BETWEEN '2013-10-01' and '2013-10-03'
-- GROUP BY 1


-- another approach: SUM(CASE WHEN LOWER(Status) LIKE "cancelled%" THEN 1.00 ELSE 0 END

