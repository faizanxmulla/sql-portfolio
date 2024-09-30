WITH CTE AS (
    SELECT   store_brand,
             customer_id,
             SUM(sales) as total_sales,
             COUNT(DISTINCT transaction_id) as transactions_count, 
             CASE 
                WHEN SUM(sales)/COUNT(transaction_id) > 30 THEN 'High'
                WHEN SUM(sales)/COUNT(transaction_id) BETWEEN 20 AND 30 THEN 'Medium'
                ELSE 'Low'
             END AS segment
    FROM     wfm_transactions JOIN wfm_stores USING(store_id)
    WHERE    EXTRACT(YEAR FROM transaction_date) = '2017'
    GROUP BY 1, 2
)
SELECT   store_brand as brand,
         segment,
         COUNT(DISTINCT customer_id),
         SUM(transactions_count) as total_transactions,
         SUM(total_sales) as total_sales, 
         SUM(total_sales) / SUM(transactions_count) as avg_basket_size
FROM     CTE
GROUP BY 1, 2