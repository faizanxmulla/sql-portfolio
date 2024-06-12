WITH monthly_purchases AS (
    SELECT   TO_CHAR(created_at, 'YYYY-MM') AS year_month,
             SUM(purchase_amt) AS total_revenue
    FROM     amazon_purchases
    GROUP BY 1
)
SELECT year_month,
       total_revenue,
       AVG(total_revenue) OVER (ORDER BY year_month
                                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
                            ) AS rolling_revenue
FROM   monthly_purchases


-- REMARKS: very similar to https://datalemur.com/questions/3d-rolling-earnings.