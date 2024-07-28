![image](https://github.com/user-attachments/assets/774f303e-5bb2-478e-b03f-ea5d6ae12043)


```sql
WITH notification_intervals AS (
    SELECT *,
           CASE 
             WHEN (delivered_at + INTERVAL '2 HOUR') <= LEAD(delivered_at, 1, '9999-12-31') OVER(ORDER BY notification_id)
             THEN (delivered_at + INTERVAL '2 HOUR') 
             ELSE LEAD(delivered_at, 1, '9999-12-31') OVER(ORDER BY notification_id)
           END AS notification_valid_till
    FROM   notifications
),
purchases_with_notifications AS (
    SELECT notification_id,
           p.user_id,
           p.product_id AS purchased_product,
           ni.product_id AS notified_product
    FROM   purchases p JOIN notification_intervals ni ON p.purchase_timestamp BETWEEN delivered_at AND notification_valid_till
)
SELECT   notification_id, 
         SUM(CASE WHEN purchased_product = notified_product THEN 1 ELSE 0 END) AS same_product_purchases,
         SUM(CASE WHEN purchased_product != notified_product THEN 1 ELSE 0 END) AS different_product_purchases
FROM     purchases_with_notifications
GROUP BY 1
ORDER BY 1
```


#### Question Link: [Namaste SQL - Q76/Hard](https://www.namastesql.com/coding-problem/76-amazon-notifications)