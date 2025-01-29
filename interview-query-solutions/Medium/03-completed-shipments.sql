SELECT shipment_id, 
       ship_date, 
       c.customer_id,
       CASE WHEN ship_date BETWEEN membership_start_date and membership_end_date THEN 'Y' ELSE 'N' END as is_member,
       quantity
FROM   customers c LEFT JOIN shipments s USING(customer_id)



-- NOTE: 

-- can also use IF statement instead of CASE WHEN : IF(ship_date BETWEEN membership_start_date AND membership_end_date, 'Y','N')
