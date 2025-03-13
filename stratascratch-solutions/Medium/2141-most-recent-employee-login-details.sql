WITH ranked_workers as (
    SELECT *, DENSE_RANK() OVER(PARTITION BY worker_id ORDER BY login_timestamp desc) as d_rn
    FROM   worker_logins
)
SELECT id, worker_id, login_timestamp, ip_address, country, region, city, device_type
FROM   ranked_workers
WHERE  d_rn=1