WITH sales_summary AS (
    SELECT   EXTRACT(WEEK FROM TO_TIMESTAMP(invoicedate, 'DD/MM/YYYY HH24:MI')) AS week_no,
             SUM(quantity * unitprice) AS total_sales,
             SUM(quantity * unitprice) FILTER (WHERE EXTRACT(ISODOW FROM TO_TIMESTAMP(invoicedate, 'DD/MM/YYYY HH24:MI')) = 1) AS start_week_sales,
             SUM(quantity * unitprice) FILTER (WHERE EXTRACT(ISODOW FROM TO_TIMESTAMP(invoicedate, 'DD/MM/YYYY  HH24:MI')) = 7) AS end_week_sales
    FROM     early_sales
    GROUP BY 1
)
SELECT   week_no,
         COALESCE(ROUND(100.0 * start_week_sales / NULLIF(total_sales, 0)), 0) AS start_week_pc,
         COALESCE(ROUND(100.0 * end_week_sales / NULLIF(total_sales, 0)), 0) AS end_week_pc
FROM     sales_summary
ORDER BY 1



-- NOTE: 
-- learnt something new: TO_TIMESTAMP(invoicedate, 'DD/MM/YYYY HH24:MI')
-- PostgreSQL expects the date format in invoicedate to be in a format like YYYY-MM-DD (ISO format) by default, but the format in your data ("26/02/2023 14:59") is in DD/MM/YYYY format.