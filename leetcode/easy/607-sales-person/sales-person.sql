SELECT sp.name
FROM   orders o JOIN company c ON (o.com_id = c.com_id AND c.name = 'RED')
                RIGHT JOIN SalesPerson sp ON sp.sales_id = o.sales_id
WHERE  o.sales_id IS NULL                     


-- aproach 2 : 

-- SELECT name 
-- FROM   salesperson
-- WHERE  sales_id not in
--         (SELECT sales_id 
--          FROM orders o LEFT JOIN company c ON o.com_id=c.com_id 
--          WHERE company.name='RED')