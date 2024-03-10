-- Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.

-- Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

-- Definition:
-- action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.


-- user_id 
-- <> confirm signup on first date but on second date. 


SELECT DISTINCT e.user_id
FROM   emails e JOIN texts t USING(email_id) 
WHERE  DATE_PART('Day', t.action_date - e.signup_date) = 1 and signup_action='Confirmed'




-- other approaches : 

1. WHERE t.action_date = e.signup_date + INTERVAL '1 day'

2. EXTRACT(DAY FROM (t.action_date - e.signup_date)) = 1

3. CAST(action_date AS DATE) = CAST(signup_date AS DATE)+1

4. t.action_date::DATE - e.signup_date::DATE = 1


-- remarks: was trying to work with DATEDIFF() and DATE_ADD(), but didn't realize that it doesn't work in PostgreSQL.
