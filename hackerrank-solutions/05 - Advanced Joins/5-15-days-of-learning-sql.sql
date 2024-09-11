-- Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

-- Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. 

-- If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.




-- Solution: 


WITH submissions_ranked as (
	SELECT submission_date, hacker_id, COUNT(*) AS submissions_count, DENSE_RANK() OVER(ORDER BY submission_date) as day_number
	FROM   submissions
	GROUP BY 1, 2
),
cumulative_submissions as (
	SELECT   *, 
	         COUNT(*) OVER(PARTITION BY hacker_id ORDER BY submission_date) as till_date_submissions, 
	         CASE WHEN day_number=COUNT(*) OVER(PARTITION BY hacker_id ORDER BY submission_date) THEN 1 ELSE 0 END as flag
	FROM     submissions_ranked
	ORDER BY 1, 2
),
ranked_submissions_per_day as (
	SELECT *, 
		   SUM(flag) OVER(PARTITION BY submission_date) AS unique_submissions, 
		   ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY submissions_count desc, hacker_id) as rn
	FROM   cumulative_submissions 
)
SELECT submission_date, unique_submissions, hacker_id, name as hacker_name
FROM   ranked_submissions_per_day rs JOIN hackers h USING(hacker_id)
WHERE  rn=1



-- Ankit Bansal YT explanation link: https://www.youtube.com/watch?v=zrCIWGHnLao&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=67




-- remarks: The data provided is wrong.