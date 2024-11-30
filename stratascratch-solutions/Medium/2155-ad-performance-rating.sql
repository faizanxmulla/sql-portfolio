WITH CTE as (
    SELECT   product_id, SUM(quantity) as total_sold
    FROM     marketing_campaign
    GROUP BY product_id
)
SELECT  product_id,
        total_sold, 
        CASE WHEN total_sold >= 30 THEN 'Outstanding'
            WHEN total_sold BETWEEN 20 and 29 THEN 'Satisfactory'
            WHEN total_sold BETWEEN 10 and 19 THEN 'Unsatisfactory'
            ELSE 'Poor'
        END as ad_performance
FROM    CTE



-- NOTE: solved on first attempt