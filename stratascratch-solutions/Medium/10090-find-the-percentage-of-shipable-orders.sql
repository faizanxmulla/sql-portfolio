SELECT 100.0 * COUNT(*) FILTER(WHERE address IS NOT NULL) / COUNT(*) as percent_shipable
FROM   customers c JOIN orders o ON c.id=o.cust_id


-- can also do this: SUM(CASE WHEN c.address IS NOT NULL THEN 1 ELSE 0 END)