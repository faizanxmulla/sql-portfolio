SELECT w.first_name, t.worker_title
FROM   worker w JOIN title t ON w.worker_id=t.worker_ref_id
WHERE  t.worker_title ILIKE '%manager%'



-- NOTE: solved on first attempt