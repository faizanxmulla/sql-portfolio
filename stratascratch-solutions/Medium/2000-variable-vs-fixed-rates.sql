SELECT   loan_id,
         COUNT(*) FILTER(WHERE rate_type='fixed') as fixed, 
         COUNT(*) FILTER(WHERE rate_type='variable') as variable
FROM     submissions
GROUP BY 1


-- NOTE: solved in first attempt