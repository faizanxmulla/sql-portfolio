SELECT   TO_CHAR(month, 'YYYY-MM-DD') as month,
         SUM(CASE WHEN product_id=1 THEN amount_sold END) as "1",
         SUM(CASE WHEN product_id=2 THEN amount_sold END) as "2",
         SUM(CASE WHEN product_id=3 THEN amount_sold END) as "3",
         SUM(CASE WHEN product_id=4 THEN amount_sold END) as "4"
FROM     monthly_sales
GROUP BY month



-- NOTE: solved on second attempt; used single inverted commas in the initial attempt