-- The first 3 digits of American phone numbers, after the international code (of +1) are called the area code.

-- How many phone calls have either a caller or receiver with a phone number with a Manhattan NYC area code (ie. +1-212-XXX-XXXX).


-- Solution 1: 

SELECT COUNT(*) AS nyc_count
FROM   phone_calls
WHERE  caller_id IN (SELECT caller_id FROM phone_info WHERE phone_number LIKE '+1-212%') OR  
       receiver_id IN (SELECT caller_id FROM phone_info WHERE phone_number LIKE '+1-212%');


-- Solution 2: using 2 LEFT joins.

SELECT SUM( CASE WHEN caller.phone_number LIKE '+1-212%' THEN 1 WHEN receiver.phone_number LIKE '+1-212%' THEN 1
ELSE 0 END) AS nyc_count
FROM    phone_calls LEFT JOIN phone_info AS caller ON phone_calls.caller_id = caller.caller_id
                    LEFT JOIN phone_info AS receiver ON phone_calls.receiver_id = receiver.caller_id;



-- Solution 3: using 2 CTE's and FILTER.

WITH caller_info AS (
    SELECT
        caller_id
    FROM phone_info
    WHERE phone_number LIKE '%+1-212%'
),
counts AS(
SELECT 
   COUNT(*) FILTER (WHERE caller_id IN (SELECT caller_id FROM caller_info)) AS n_callers,
   COUNT(*) FILTER (WHERE receiver_id IN (SELECT caller_id FROM caller_info)) AS n_receivers
FROM phone_calls
)
SELECT 
    n_callers + n_receivers AS nyc_count
FROM counts;



-- my approach: 

SELECT count(*) as nyc_count
FROM   phone_calls pc JOIN phone_info pi ON pi.caller_id=pc.caller_id or pi.caller_id=pc.receiver_id
WHERE  country_id='US' and SUBSTRING(phone_number, 4, 3)='212'



-- remarks: 