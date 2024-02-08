-- Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.


-- Solution 1 (as well as first approach): 

SELECT   DISTINCT sender_id, COUNT(message_id) as messages_count
FROM     messages
WHERE    sent_date BETWEEN '08/01/2022' and '08/31/2022'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    2



-- other ways to handle dates : 

-- 1. EXTRACT(MONTH FROM sent_date) = '8' AND EXTRACT(YEAR FROM sent_date) = '2022'

-- 2. DATE_TRUNC('month', sent_date) = '08/01/2022'

-- 3. DATE_PART('month', sent_date) = '08'AND DATE_PART('year', sent_date) = '2022'