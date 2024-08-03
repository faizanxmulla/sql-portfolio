### Problem Statement

Write a query to provide the date for the nth occurence of Sunday in future from given date.

### Query

```sql
-- code in PostgreSQL

-- here n=3, so 3rd Sunday after 2022-01-03

WITH next_sunday AS (
    SELECT today_date + (7 - EXTRACT(ISODOW FROM today_date))::INT AS first_sunday
    FROM (
        SELECT DATE '2024-07-30' AS today_date
    ) x
)
SELECT (first_sunday + INTERVAL '1 week' * (3 - 1))::DATE AS nth_sunday
FROM   next_sunday;

-- ====================================================================

-- code in SQL server

DECLARE @today_date DATE;
DECLARE @n INT;

SET @today_date = '2024-07-30';
SET @n = 3;                      

SELECT DATEADD(WEEK, @n - 1, DATEADD(DAY, 8 - DATEPART(WEEKDAY, @today_date), @today_date));
```

Here's a list of similar commands for calculating the first occurrence of each day of the week (Sunday to Saturday) from a given date using PostgreSQL:

### Commands for Each Day of the Week

- **Sunday:**
  ```sql
  today_date + (7 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_sunday
  ```

- **Monday:**
  ```sql
  today_date + (8 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_monday
  ```

- **Tuesday:**
  ```sql
  today_date + (9 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_tuesday
  ```

- **Wednesday:**
  ```sql
  today_date + (10 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_wednesday
  ```

- **Thursday:**
  ```sql
  today_date + (11 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_thursday
  ```

- **Friday:**
  ```sql
  today_date + (12 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_friday
  ```

- **Saturday:**
  ```sql
  today_date + (13 - EXTRACT(ISODOW FROM today_date)) % 7 AS first_saturday
  ```