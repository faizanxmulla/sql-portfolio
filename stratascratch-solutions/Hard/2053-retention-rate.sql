WITH year_month_cte AS (
    SELECT TO_CHAR(date, 'YYYY-MM') AS year_month, account_id, user_id
    FROM   sf_events
),
dec_2020_cte AS (
    SELECT year_month as dec_2020, account_id, user_id
    FROM   year_month_cte
    WHERE  year_month='2020-12'
),
jan_2021_cte AS (
    SELECT year_month as jan_2021, account_id, user_id
    FROM   year_month_cte
    WHERE  year_month='2021-01'
),
dec_2020_retained AS (
    SELECT   d2.account_id, 
             COUNT(DISTINCT d2.user_id) AS dec_2020_retained_count
    FROM     dec_2020_cte d2 LEFT JOIN year_month_cte ymc USING(user_id)
    WHERE    year_month > '2020-12'
    GROUP BY 1
),
jan_2021_retained AS (
    SELECT   j1.account_id, 
             COUNT(DISTINCT j1.user_id) AS jan_2021_retained_count
    FROM     jan_2021_cte j1 LEFT JOIN year_month_cte ymc USING(user_id)
    WHERE    year_month > '2021-01'
    GROUP BY 1
),
dec_2020_total AS (
    SELECT   account_id, 
             COUNT(DISTINCT user_id) AS dec_2020_total_count
    FROM     dec_2020_cte
    GROUP BY 1
),
jan_2021_total AS (
    SELECT   account_id, 
             COUNT(DISTINCT user_id) AS jan_2021_total_count
    FROM     jan_2021_cte
    GROUP BY 1
)
SELECT d2r.account_id,
       COALESCE(
            (j1r.jan_2021_retained_count::decimal / NULLIF(j1t.jan_2021_total_count, 0)) / 
            (d2r.dec_2020_retained_count::decimal / NULLIF(d2t.dec_2020_total_count, 0)), 
        0) AS retention_rate_ratio
FROM   dec_2020_retained d2r LEFT JOIN jan_2021_retained j1r USING(account_id)
                             LEFT JOIN dec_2020_total d2t USING(account_id)
                             LEFT JOIN jan_2021_total j1t USING(account_id)



-- NOTE: solution is very long; and there will be an optimized way of writing the query; but it is very straighforward and easy to understand.