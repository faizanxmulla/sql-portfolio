-- Write an SQL query to find the account_id of the accounts that should be banned from Leetflex. 

-- An account should be banned if it was logged in at some moment from two different IP addresses.



-- Solution 1: using JOIN.

SELECT DISTINCT a.account_id 
FROM   LogInfo a JOIN LogInfo b ON (a.account_id = b.account_id and a.ip_address <> b.ip_address)
WHERE  a.login BETWEEN b.login and b.logout


-- Solution 2: using cte and LEAD().

WITH cte
     AS (SELECT *,
                Lead(login)
                  OVER(
                    partition BY account_id
                    ORDER BY account_id) AS next_login
         FROM   loginfo)
SELECT account_id
FROM   cte
WHERE  next_login <= logout 




-- my approach: also thought of using RANK()

-- LogInfo 
-- duplicates exists --> DISTINCT 
-- USE rank() window function
-- partition by account_id 


SELECT DISTINCT a.account_id 
FROM   LogInfo a, LogInfo b 
WHERE  a.login = b.login and a.ip_address <> b.ip_address
