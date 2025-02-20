SELECT c.first_name
FROM   customers c LEFT JOIN orders o 
ON     c.id=o.cust_id
       and o.order_date BETWEEN '2019-02-01' and '2019-03-01'
WHERE  o.id IS NULL