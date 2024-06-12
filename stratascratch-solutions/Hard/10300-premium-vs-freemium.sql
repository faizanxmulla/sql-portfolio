WITH customers_cte AS (
    SELECT   date, 
             SUM(downloads) FILTER(WHERE paying_customer='no') AS non_paying,
             SUM(downloads) FILTER(WHERE paying_customer='yes') AS paying
    FROM     ms_download_facts mf JOIN ms_user_dimension md USING(user_id)
                                  JOIN ms_acc_dimension ad USING(acc_id)
    GROUP BY 1
    ORDER BY 1
)
SELECT date, non_paying, paying
FROM   customers_cte
WHERE  non_paying > paying