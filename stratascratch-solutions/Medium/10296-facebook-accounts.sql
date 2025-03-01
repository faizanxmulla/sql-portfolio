SELECT COUNT(acc_id) FILTER(WHERE status='closed') / COUNT(*)::numeric as closed_ratio
FROM   fb_account_status
WHERE  date='2020-01-10'