![image](https://github.com/user-attachments/assets/3281db46-b54c-4aee-9b01-0ae957a9636b)


### Solution Query

```sql
WITH weight_cte AS (
    SELECT *, SUM(weight_kg) OVER(PARTITION BY lift_id ORDER BY weight_kg) AS cumulative_weight
    FROM   lift_passengers
)
SELECT   id, STRING_AGG(passenger_name, ',') AS passenger_list
FROM     weight_cte wc JOIN lifts l ON wc.lift_id=l.id
WHERE    cumulative_weight < capacity_kg
GROUP BY 1
```

#### Question Link: [Namaste SQL - Q15/Hard](https://www.namastesql.com/coding-problem/15-lift-overloaded-part-1)