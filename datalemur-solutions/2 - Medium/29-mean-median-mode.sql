-- You're given a list of numbers representing the number of emails in the inbox of Microsoft Outlook users. 
-- Before the Product Management team can start developing features related to bulk-deleting email or achieving inbox zero, 
-- they simply want to find the mean, median, and mode for the emails.

-- Display the output of mean, median and mode (in this order), with the mean rounded to the nearest integer. 
-- It should be assumed that there are no ties for the mode.

-- inbox_stats Table:

-- Column Name	Type
-- user_id	integer
-- email_count	integer

-- inbox_stats Example Input:

-- user_id	email_count
-- 123	    100
-- 234	    200
-- 345	    300
-- 456	    200
-- 567	    200

-- Example Output:

-- mean	median	mode
-- 200	    200	    200


-- Explanation
-- The mean is calculated by adding up all the email counts and dividing by the number of users, 
-- resulting in a mean of 200 (i.e., (100 + 200 + 300 + 200 + 200) / 5).
-- The mode is the value that occurs most frequently, which is 200 in this case, since it appears three times, more than any other value.
-- The median is the middle value of the ordered dataset. When the data is arranged in order from smallest to largest 
-- (100, 200, 200, 200, 300), the median is also 200, which separates the lower half from the higher half of the values.
-- The dataset you are querying against may have different input & output - this is just an example!



SELECT ROUND(AVG(email_count)) as mean,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY email_count) as median, 
       MODE() WITHIN GROUP (ORDER BY email_count) as mode
FROM   inbox_stats


-- remarks: wasn't aware of MODE() function in PostgreSQL.