-- You are given the two tables containing information on Etsy’s user signups and purchases. 

-- Write a query to obtain the percentage of users who signed up and made a purchase within 7 days of signing up. 
-- The result should be rounded to the nearest 2 decimal places.

-- Assumptions:

-- Signups who didn't buy any products yet should also count as part of the percentage of users who signed up and made a purchase within 7 days of signing up.

-- If the signup date is on 06/21/2022 and the purchase date on 06/26/2022, then the user makes up part of the percentage of users who signed up and purchased within the 7 days of signing up.

-- signups Table:

-- Column Name	Type
-- user_id	integer
-- signup_date	datetime

-- signups Example Input:

-- user_id	signup_date
-- 445	06/21/2022 12:00:00
-- 742	06/19/2022 12:00:00
-- 648	06/24/2022 12:00:00
-- 789	06/27/2022 12:00:00
-- 123	06/27/2022 12:00:00

-- user_purchases Table:

-- Column Name	Type
-- user_id	integer
-- product_id	integer
-- purchase_amount	decimal
-- purchase_date	datetime

-- user_purchases Example Input:

-- user_id	product_id	purchase_amount	purchase_date
-- 244	7575	45.00	06/22/2022 12:00:00
-- 742	1241	50.00	06/28/2022 12:00:00
-- 648	3632	55.50	06/25/2022 12:00:00
-- 123	8475	67.30	06/29/2022 12:00:00
-- 244	2341	74.10	06/30/2022 12:00:00

-- Example Output:

-- single_purchase_pct
-- 40.00


-- Explanation: The only users who purchased within 7 days of signing up are users 648 and 123. The total count of given signups is 5, resulting in a percentage of 2/5 = 40%.


-- Solution 1:

WITH signups_purchases AS (
    SELECT   s.user_id,
             s.signup_date,
             MIN(up.purchase_date) AS first_purchase_date
    FROM     signups s LEFT JOIN user_purchases up USING(user_id)
    GROUP BY 1, 2
),
purchases_within_7_days AS (
    SELECT user_id,
           signup_date,
           first_purchase_date,
           CASE 
               WHEN first_purchase_date IS NOT NULL 
                    AND first_purchase_date <= signup_date + INTERVAL '7 days' 
               THEN 1 ELSE 0 
           END AS within_7_days
    FROM   signups_purchases
)
SELECT ROUND(100.0 * SUM(within_7_days) / COUNT(*), 2) AS single_purchase_pct
FROM   purchases_within_7_days;




-- my initial approach: (didnt consider the FIRST purchase date; also LEFT JOIN)

SELECT ROUND(100.0 * 
                COUNT(user_id) FILTER(WHERE EXTRACT(DAY FROM purchase_date - signup_date) < 7) / 
                COUNT(*)
            , 2) as single_purchase_pct
FROM   signups s JOIN user_purchases up USING(user_id)


-- Solution 2:
-- correct solution: (to my initial approach)

WITH signups_purchases AS (
    SELECT   s.user_id,
             s.signup_date,
             MIN(up.purchase_date) AS first_purchase_date
    FROM     signups s LEFT JOIN user_purchases up USING(user_id)
    GROUP BY 1, 2
)
SELECT ROUND(100.0 * 
                COUNT(user_id) FILTER(WHERE EXTRACT(DAY FROM first_purchase_date - signup_date) < 7) / 
                COUNT(*)
            , 2) as single_purchase_pct
FROM   signups_purchases