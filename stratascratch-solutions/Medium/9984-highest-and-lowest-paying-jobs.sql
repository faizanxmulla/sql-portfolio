SELECT   jobtitle, 
         MAX(totalpay) - MIN(totalpay) as difference,
         MAX(totalpay) / MIN(totalpay) as ratio,
         MAX(totalpay) as max_totalpay, 
         MIN(totalpay) as min_totalpay
FROM     sf_public_salaries
WHERE    totalpay > 0
GROUP BY jobtitle