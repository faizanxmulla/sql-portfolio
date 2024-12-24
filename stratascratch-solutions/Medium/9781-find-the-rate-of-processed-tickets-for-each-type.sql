SELECT   type, 
         1.0 * COUNT(complaint_id) FILTER(WHERE processed='TRUE') / COUNT(*) as processed_rate
FROM     facebook_complaints
GROUP BY type



-- NOTE: solved on first attempt