SELECT transaction_id  
FROM   boi_transactions 
WHERE  EXTRACT(HOUR FROM time_stamp) NOT BETWEEN 9 and 15
       OR EXTRACT(ISODOW FROM time_stamp) IN (6, 7)
       OR EXTRACT(DAY from time_stamp) IN (25,26)



-- NOTE: solved on first attempt