![image](https://github.com/user-attachments/assets/7cbcd5ad-42a5-4450-9728-39268385a48f)


### Solution Query

```sql
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY customer_name ORDER BY order_date DESC) AS rn, 
           COUNT(*) OVER(PARTITION BY customer_name) AS order_count
    FROM   orders
)
SELECT   order_id, order_date, customer_name, product_name, sales
FROM     CTE
WHERE    rn=2 OR order_count=1
ORDER BY 3
```