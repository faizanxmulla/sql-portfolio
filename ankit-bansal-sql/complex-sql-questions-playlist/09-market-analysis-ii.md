### Problem Statement | [Leetcode Link](https://leetcode.com/problems/market-analysis-ii/description/)

Write a solution to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

It is guaranteed that no seller sold more than one item on a day.

### Solution Query

```sql
WITH ranked_orders AS (
    SELECT u.user_id, 
           favorite_brand, 
           item_brand,
           RANK() OVER(PARTITION BY o.seller_id ORDER BY o.order_date) AS rn
    FROM   users u LEFT JOIN orders o ON u.user_id = o.seller_id
                   LEFT JOIN items i ON o.item_id = i.item_id
)
SELECT   u.user_id AS seller_id,
         COALESCE(
              MAX(CASE 
                    WHEN r.rn = 2 AND r.favorite_brand = r.item_brand THEN 'yes'
                    WHEN r.rn IS NULL OR r.rn < 2 THEN 'no'
                  END), 'no'
         ) AS "2nd_item_fav_brand"
FROM     users u LEFT JOIN ranked_orders r USING(user_id)
GROUP BY 1
```