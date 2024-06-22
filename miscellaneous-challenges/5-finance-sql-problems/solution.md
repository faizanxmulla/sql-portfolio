## Solutions

### 1. Stale / Flat Bond Prices

```sql
WITH CTE AS (
	SELECT   *, 
			 ROW_NUMBER() OVER(PARTITION BY bond_id ORDER BY date DESC) -
			 ROW_NUMBER() OVER(PARTITION BY bond_id, price ORDER BY date DESC) as price_streak
	FROM     bond_prices
)
SELECT   bond_id, COUNT(*) AS flat_prices_count
FROM     CTE
WHERE    price_streak=0
GROUP BY 1
HAVING   COUNT(*) >= 5
```

---

### 2. Convert and fill FX values for fund prices


```sql


```

---

### 3. Calculate filled_close stock prices


```sql


```

---

### 4. New definition of default


```sql


```

---

### 5. Adjust missed payments based on recoveries


```sql


```

---