-- A senior analyst is interested to know the activation rate of specified users in the emails table. 

-- Write a query to find the activation rate. 
-- Round the percentage to 2 decimal places.


SELECT ROUND(1.0 * SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 ELSE 0 END) / COUNT(distinct email_id), 2) as activation_rate
FROM   emails e LEFT JOIN texts t USING(email_id)



-- remarks: 
-- 1. tried using "count filter when" fisrt --> didnt work.
-- 2. was doing COUNT(*) initially.
