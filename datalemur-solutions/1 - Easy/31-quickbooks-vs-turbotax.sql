-- Intuit provides a range of tax filing products, including TurboTax and QuickBooks, available in various versions.

-- Write a query to determine the total number of tax filings made using TurboTax and QuickBooks. Each user can file taxes once a year using only one product.



SELECT SUM (CASE WHEN LOWER(product) LIKE 'turbotax%' THEN 1 ELSE 0 END) AS turbotax_total,
       SUM (CASE WHEN LOWER(product) LIKE 'quickbooks%' THEN 1 ELSE 0 END) AS quickbooks_total
FROM   filed_taxes;


-- alternative: could have used SUM() FILTER(WHERE ...) instead. 


-- NOTE: for official solution refer : question 5 of https://datalemur.com/blog/data-analyst-sql-interview-questions