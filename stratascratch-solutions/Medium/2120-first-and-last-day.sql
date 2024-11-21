SELECT   p.promotion_id,
         100.0 * COUNT(CASE WHEN o.date = p.start_date THEN 1 END) / COUNT(*) as start_date_percentage,
         100.0 * COUNT(CASE WHEN o.date = p.end_date THEN 1 END) / COUNT(*) as end_date_percentage
FROM     online_sales_promotions p JOIN online_orders o ON p.promotion_id = o.promotion_id
GROUP BY p.promotion_id



-- NOTE: solved on second attempt; was using SUM() instead of COUNT(), so instead of 0 was getting NULL values.