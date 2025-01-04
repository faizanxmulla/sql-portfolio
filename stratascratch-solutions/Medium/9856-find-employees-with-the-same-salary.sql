SELECT   a.worker_id, 
         a.first_name,
         a.salary
FROM     worker a JOIN worker b 
ON       a.salary=b.salary 
         and a.worker_id <> b.worker_id
ORDER BY a.salary desc