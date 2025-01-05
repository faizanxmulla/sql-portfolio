SELECT   department, COUNT(worker_id) as num_of_workers
FROM     worker
GROUP BY department
HAVING   COUNT(worker_id) < 4