WITH all_sales as (
    SELECT branch_id, total_sales, '2021' as year
    FROM   sales_2021
    UNION 
    SELECT branch_id, total_sales, '2022'
    FROM   sales_2022
)
SELECT   branch_id, 
         SUM(CASE WHEN year='2021' THEN total_sales ELSE 0 END) as total_sales_2021,
         SUM(CASE WHEN year='2022' THEN total_sales ELSE 0 END) as total_sales_2022
FROM     all_sales
GROUP BY branch_id



-- my initial attempt / thought process

-- but noticed not all branch_id are present in all years.

SELECT   branch_id,
         SUM(s1.total_sales) as total_sales_2021,
         SUM(s2.total_sales) as total_sales_2022
FROM     sales_2021 s1 JOIN sales_2022 s2 ON s1.branch_id=s2.branch_id
GROUP BY branch_id



-- NOTE: can also use FILTER() clause instead of CASE WHEN.