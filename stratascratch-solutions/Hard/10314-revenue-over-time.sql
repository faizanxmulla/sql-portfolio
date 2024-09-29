WITH monthly_purchases AS (
    SELECT   TO_CHAR(created_at, 'YYYY-MM') AS year_month,
             SUM(purchase_amt) AS total_revenue
    FROM     amazon_purchases
    WHERE    purchase_amt > 0
    GROUP BY 1
)
SELECT year_month,
       AVG(total_revenue) OVER (ORDER BY year_month
                                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_revenue
FROM   monthly_purchases


-- NOTE: earlier forgot this condition: 
-- "Do not include returns which are represented by negative purchase values."

-- REMARKS: very similar to https://datalemur.com/questions/3d-rolling-earnings.