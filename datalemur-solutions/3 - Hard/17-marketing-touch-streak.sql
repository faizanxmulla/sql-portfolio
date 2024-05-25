-- Marketing Touch Streak [Snowflake SQL Interview Question]

-- As a Data Analyst on Snowflake's Marketing Analytics team, your objective is to analyze customer relationship management (CRM) data and identify contacts that satisfy two conditions:

-- Contacts who had a marketing touch for three or more consecutive weeks.
-- Contacts who had at least one marketing touch of the type 'trial_request'.
-- Marketing touches, also known as touch points, represent the interactions or points of contact between a brand and its customers.

-- Your goal is to generate a list of email addresses for these contacts.


-- marketing_touches Table:

-- Column Name	Type
-- event_id	integer
-- contact_id	integer
-- event_type	string ('webinar', 'conference_registration', 'trial_request')
-- event_date	date


-- `marketing_touches` Example Input:

-- event_id	contact_id	event_type	event_date
-- 1	1	webinar	4/17/2022
-- 2	1	trial_request	4/23/2022
-- 3	1	whitepaper_download	4/30/2022
-- 4	2	handson_lab	4/19/2022
-- 5	2	trial_request	4/23/2022
-- 6	2	conference_registration	4/24/2022
-- 7	3	whitepaper_download	4/30/2022
-- 8	4	trial_request	4/30/2022
-- 9	4	webinar	5/14/2022


-- `crm_contacts` Table:

-- Column Name	Type
-- contact_id	integer
-- email	string

-- `crm_contacts` Example Input:

-- contact_id	email
-- 1	andy.markus@att.net
-- 2	rajan.bhatt@capitalone.com
-- 3	lissa_rogers@jetblue.com
-- 4	kevinliu@square.com


-- Example Output:

-- email
-- andy.markus@att.net



WITH week_data AS (
    SELECT contact_id, 
           event_type, 
           DATE_TRUNC('week', event_date) AS curr_week, 
           LAG(DATE_TRUNC('week', event_date)) OVER(PARTITION BY contact_id ORDER BY event_date) AS prev_week, 
           LEAD(DATE_TRUNC('week', event_date)) OVER(PARTITION BY contact_id ORDER BY event_date) AS next_week
    FROM   marketing_touches
),
trial_requests AS (
    SELECT DISTINCT contact_id
    FROM   marketing_touches
    WHERE  event_type = 'trial_request'
)
SELECT DISTINCT c.email
FROM   week_data wd JOIN trial_requests tr USING(contact_id)
                    JOIN crm_contacts c USING(contact_id)
WHERE  wd.prev_week = wd.curr_week - INTERVAL '1 week' AND 
       wd.next_week = wd.curr_week + INTERVAL '1 week';






-- NOTE: for official solution refer : question 17 of https://datalemur.com/blog/advanced-sql-interview-questions