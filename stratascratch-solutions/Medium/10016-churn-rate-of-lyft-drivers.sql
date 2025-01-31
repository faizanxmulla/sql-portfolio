SELECT 1.0 * COUNT(*) FILTER(WHERE end_date IS NOT NULL) / COUNT(*) as global_churn_rate
FROM   lyft_drivers



-- NOTE: can also use CASE WHEN instead of FILTER(WHERE ...)