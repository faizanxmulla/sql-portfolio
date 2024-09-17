![image](https://github.com/user-attachments/assets/656f4c72-7627-405f-86ea-ae3aaca62175)


### Solution Query

```sql
SELECT   category, COALESCE(MIN(CASE WHEN pu.product_id IS NOT NULL THEN price END), 0) AS price
FROM     products pr LEFT JOIN purchases pu ON pr.id=pu.product_id AND stars IN (4, 5)
GROUP BY 1
ORDER BY 1
```