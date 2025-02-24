SELECT   product_name, COUNT(transaction_id) as count
FROM     excel_sql_inventory_data i JOIN excel_sql_transaction_data t 
ON       i.product_id = t.product_id
GROUP BY product_name, i.product_id
ORDER BY i.product_id