SELECT   type, 
         COUNT(complaint_id) FILTER(WHERE processed='TRUE') AS processed_complaints, 
         COUNT(complaint_id) FILTER(WHERE processed='FALSE') AS non_processed_complaints
FROM     facebook_complaints
GROUP BY 1