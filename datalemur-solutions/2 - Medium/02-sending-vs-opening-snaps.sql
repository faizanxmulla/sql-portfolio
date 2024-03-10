-- Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

-- Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

-- Notes:

--  - Calculate the following percentages:
--     - time spent sending / (Time spent sending + Time spent opening)
--     - Time spent opening / (Time spent sending + Time spent opening)

--  - To avoid integer division in percentages, multiply by 100.0 and not 100.



SELECT   age_bucket,
         round(100.0 * Sum(a.time_spent) filter(WHERE activity_type='send') / sum(a.time_spent), 2) AS send_perc,
         round(100.0 * sum(a.time_spent) filter(WHERE activity_type='open') / sum(a.time_spent), 2) AS open_perc
FROM     activities a JOIN age_breakdown ab using (user_id)
WHERE    a.activity_type IN('send',
                            'open')
GROUP BY 1


-- remarks: didn't think of this: WHERE a.activity_type IN('send', 'open')