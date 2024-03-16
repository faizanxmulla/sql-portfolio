-- more easy approach: using MIN and MAX.

SELECT   p.product_id, p.product_name 
FROM     Product p JOIN Sales s USING (product_id)
GROUP BY 1
HAVING   MIN(s.sale_date) >= "2019-01-01" AND MAX(s.sale_date) <= "2019-03-31"


-- approach: accepts the initial testcase, but fails 4/13 in the rest of the testcases.

-- SELECT p.product_id, p.product_name
-- FROM   Product p JOIN Sales s USING(product_id)
-- WHERE  product_id not in (
--     SELECT product_id
--     FROM   Sales
--     WHERE  sale_date not BETWEEN '2019-01-01' and '2019-03-31'
-- )


-- my initial approach: 

-- SELECT p.product_id, p.product_name
-- FROM   Product p JOIN Sales s USING(product_id)
-- WHERE  sale_date BETWEEN '2019-01-01' and '2019-03-31'


-- remarks: was not sure on how to handle the "only" part of the question.