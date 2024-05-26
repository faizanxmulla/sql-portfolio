-- As a Data Analyst on Snowflake's Marketing Analytics team, you're analyzing the CRM to determine what percent of marketing touches were of type "webinar" in April 2022.

-- Round your percentage to the nearest integer.

-- Did you know? Marketing touches, also known as touch points are the brand's (Snowflake's) point of contact with the customers, from start to finish.

-- marketing_touches Table:

-- Column Name	Type
-- event_id	integer
-- contact_id	integer
-- event_type	string
-- event_date	date

-- marketing_touches Example Input:

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

-- Example Output:

-- webinar_pct
-- 13



-- Solution:

WITH CTE AS (
    SELECT SUM(CASE WHEN event_type = 'webinar' THEN 1 ELSE 0 END) AS webinar_events,
           COUNT(event_id) AS total_touch_points
    FROM   marketing_touches
    WHERE  event_date BETWEEN '04/01/2022' AND '04/30/2022'
)
SELECT ROUND(100.0 * webinar_events / total_touch_points) AS webinar_pct
FROM   CTE
