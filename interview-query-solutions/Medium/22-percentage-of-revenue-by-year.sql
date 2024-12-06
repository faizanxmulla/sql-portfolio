WITH yearwise_revenue_cte as (
    SELECT   EXTRACT(YEAR FROM created_at) as year,
             SUM(amount - amount_refunded) as yearwise_revenue
    FROM     annual_payments
    GROUP BY 1
)
,get_first_last_years as (
    SELECT *,
           FIRST_VALUE(year) OVER(ORDER BY year) as first_year,
           FIRST_VALUE(year) OVER(ORDER BY year DESC) as last_year
    FROM   yearwise_revenue_cte
)
,get_totals as (
    SELECT SUM(yearwise_revenue) as total_revenue,
           MAX(CASE WHEN year = first_year THEN yearwise_revenue ELSE 0 END) as first_year_revenue,
           MAX(CASE WHEN year = last_year THEN yearwise_revenue ELSE 0 END) as last_year_revenue
    FROM   get_first_last_years
)
SELECT ROUND(CAST(100.0 * first_year_revenue / total_revenue as numeric), 2) as percent_first,
       ROUND(CAST(100.0 * last_year_revenue / total_revenue as numeric), 2) as percent_last
FROM   get_totals




-- NOTE: 

-- did it way more long than it should be.

-- also didn't consider "amount - amount_refunded" in the initial attempt.

-- also could have used MIN and MAX to find the first and last years: 

-- MIN(EXTRACT(YEAR FROM created_at)) OVER() as first_year,
-- MAX(EXTRACT(YEAR FROM created_at)) OVER() as last_year