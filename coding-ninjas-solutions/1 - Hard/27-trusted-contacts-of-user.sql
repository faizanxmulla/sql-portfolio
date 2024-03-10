-- Write an SQL query to find the following for each invoice_id:

-- - customer_name: The name of the customer the invoice is related to.
-- - price: The price of the invoice.
-- - contacts_cnt: The number of contacts related to the customer.
-- - trusted_contacts_cnt: The number of contacts related to the customer and at the same time they are customers to the shop. (i.e His/Her email exists in the Customers table.)

-- Order the result table by invoice_id.


SELECT i.invoice_id, 
       cu.customer_name, 
       COALESCE(i.price, 0) as price, 
       COUNT(DISTINCT co.contact_name) as contacts_cnt,
       COUNT(DISTINCT CASE WHEN c.customer_id IS NOT NULL THEN co.contact_name END) as trusted_contacts_cnt
FROM   Customers cu LEFT JOIN Contacts co ON cu.customer_id = co.user_id
                    LEFT JOIN Invoices i ON cu.customer_id = i.user_id
                    LEFT JOIN Customers c ON co.contact_email = c.email
GROUP BY 1, 2, 3
ORDER BY 1


-- remarks: couldnt figure out the correct way to join the 3 tables. also,the order of joining tables matters.