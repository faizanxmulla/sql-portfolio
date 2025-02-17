SELECT 100.0 * SUM(CASE WHEN ts_accepted_at IS NOT NULL THEN 1 ELSE 0 END) / 
               COUNT(*) as accetance_rate
FROM   airbnb_contacts


-- alternate solutions:

-- 1. 100.0 * COUNT(ts_accepted_at) / COUNT(ts_contact_at)
-- 2. 100.0 * COUNT(ts_contact_at) FILTER(WHERE ts_accepted_at IS NOT NULL) / COUNT(ts_contact_at)