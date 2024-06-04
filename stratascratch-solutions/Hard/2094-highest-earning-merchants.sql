WITH daily_revenue_earned AS ( 
    SELECT   TO_CHAR(order_timestamp, 'YYYY-MM-DD') AS date, 
             merchant_id,
             ROUND(SUM(total_amount_earned)::NUMERIC, 2) as current_day_revenue
    FROM     order_details
    GROUP BY 1, 2
    ORDER BY 1, 2
),
prev_day_revenue_earned AS (
    SELECT date, 
          merchant_id, 
          current_day_revenue, 
          LAG(current_day_revenue) OVER(PARTITION BY date ORDER BY current_day_revenue DESC) as prev_day_max_revenue
    FROM   daily_revenue_earned
)
SELECT   date, 
         merchant_id
FROM     prev_day_revenue_earned
WHERE    current_day_revenue = prev_day_max_revenue AND 
         prev_day_max_revenue IS NOT NULL
GROUP BY 1, 2
ORDER BY 1



-- REMARKS: answer might be slightly wrong; meaning not 100% sure. 