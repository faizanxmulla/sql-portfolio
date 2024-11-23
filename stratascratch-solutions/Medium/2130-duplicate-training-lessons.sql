SELECT   ut.u_name, 
         td.training_id,
         td.training_date,
         COUNT(*) as n_attended
FROM     users_training ut JOIN training_details td ON ut.u_id=td.u_id
GROUP BY 1, 2, 3
HAVING   COUNT(*) > 1



-- NOTE: solved on second attempt; didnt put the HAVING clause in the first attempt