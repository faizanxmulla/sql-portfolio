WITH get_host_count as (
    SELECT   EXTRACT(YEAR FROM host_since) as year, 
             COUNT(DISTINCT id) as current_year_host
    FROM     airbnb_search_details
    GROUP BY 1
)
SELECT year, 
       current_year_host,
       LAG(current_year_host) OVER(ORDER BY year) as prev_year_host,
       ROUND(100 * (current_year_host - LAG(current_year_host) OVER(ORDER BY year)) / LAG(current_year_host) OVER(ORDER BY year)::FLOAT) as estimated_growth
FROM   get_host_count



-- NOTE: 

-- got stuck in round --> to remember: make the denominator cast as float.