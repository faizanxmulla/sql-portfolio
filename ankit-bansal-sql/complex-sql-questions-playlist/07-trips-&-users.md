### Problem Statement | [Leetcode Link](https://leetcode.com/problems/trips-and-users/)

Write a solution to find the cancellation rate of requests with unbanned users (both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03". 

Round Cancellation Rate to two decimal points.


### Solution Query

```sql
SELECT   request_at AS "Day",
         ROUND((SUM(CASE WHEN Status != 'completed' THEN 1.00 ELSE 0 END) / COUNT(id)), 2) AS "Cancellation Rate"
FROM     Trips t JOIN Users u1 ON t.client_id = u1.users_id AND u1.banned = 'No'
                 JOIN Users u2 ON t.driver_id = u2.users_id AND u2.banned = 'No'
WHERE    t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY 1


-- another approach: SUM(CASE WHEN LOWER(Status) LIKE "cancelled%" THEN 1.00 ELSE 0 END
```

